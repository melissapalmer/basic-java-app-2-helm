# Deploying a Spring Boot app to K8s

In this post I create a greeting RESTFul API with Spring, that queries a DB for its hello strings. Use Docker to create an image and run it in a container. I'll cover how to use docker compose to run multiple containers for the application (our app, and postgres DB). Finally deploying the app to a K8s cluster using Helm package manager.

Thank you to **The Practical Developer** as is post at: https://thepracticaldeveloper.com/2017/12/11/dockerize-spring-boot/ allot of this is based off of what he taught is there. 

**I go through the following technology stack, during this post:**

- [Spring](https://spring.io/) is an application framework and inversion of control container for the Java platform.
- [Docker](https://www.docker.com/)  is used to run software called "containers". Containers are isolated from each other and bundle their own application, tools, libraries and configuration files.
- [Docker Compose](https://docs.docker.com/compose/) is a tool for defining and running multi-container applications. 
- [Kubernetes](https://kubernetes.io/) (commonly known as K8s) is an open-source container-orchestration system for automating deployment, scaling and management of containerized applications.

- [Helm](https://docs.helm.sh/) is a package manager for K8s, it simplifies the installation of an application and its dependencies into a K8s cluster.

# 01-Create a Spring Boot Rest API

For this step, I have assumed prior knowledge of Spring Boot, Maven and creating Restful APIs. If not checkout the following Spring.io guides: [Building a RESTful Web Service](https://spring.io/guides/gs/rest-service/), [Building REST services with Spring](https://spring.io/guides/tutorials/bookmarks/), [Accessing JPA Data with REST](https://spring.io/guides/gs/accessing-data-rest/)

You can also grab the code in my repo, on the 01-springboot-app branch in [GitHub](https://github.com/melissapalmer/basic-java-app-2-helm/tree/01-springboot-app)

**This application includes:** 

- An endpoint `/hello` that'll respond with various greetings text sourced from a DB. 
- Spring Actuator: which exposes health check endpoints, that will be used later on

**Few things to notice**

- application.yml includes the setting `spring.datasource.platform=h2` Spring in turn knows to use the  `data-h2.sql` file to initialise the h2 DB on start up. 
- I have done this so that later, we can initialise the 'real' DB in other ways. It will help see how a 'real' DB is used vs. the H2 in memory DB.

**Compiling and Running the app** 

- Build Using `./mvnw clean package`
- Run Using `java -jar target/docker-2-helm.jar` or `./mvnw spring-boot:run`

Go to http://localhost:8080/hello to see a hello message. 
Also test out the Spring Actuator endpoints: http://localhost:8080/actuator and http://localhost:8080/actuator/health

**So far we have done nothing with Docker**, however it is important to understand, that we've: 

- only built and run the application locally: **using a pre-installed version** of Java &/or Maven. 
- If we were to hand this over to the an OP's team at this point: 
  - we'd need to specify to them what version of Java is needed

# **02-Containerise It** 

This step takes the Spring Boot application and creates a Docker image. You'll need to ensure you have Docker installed.

## Prerequisites

- [Docker](https://docs.docker.com/v17.09/engine/installation/linux/docker-ce/ubuntu/)		Install Instructions: `sudo apt install docker`

Create a Dockerfile, as below, in your project. This is used to define an image, build it and run it using Docker commands.

```dockerfile
# Step : Build image
FROM maven:3.5.3-jdk-8-alpine as BUILD
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src/ /build/src/
RUN mvn package

# Step : Package image
FROM openjdk:8-jre-alpine as APP
EXPOSE 8080
COPY --from=BUILD /build/target/docker-2-helm.jar app.jar
#To reduce Tomcat startup time we added a system property pointing to "/dev/urandom" as a source of entropy.
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

**Describe Docker File**

I'm using a multi-stage Dockerfile here, Docker's multi-stage feature allows a Dockerfile to contain more than one FROM line. Each stage starts with a new FROM line and a fresh context.

In this case there are two FROM instructions. This means this is a two-stage build.

- `FROM` command tells docker which base image to start building your own image off
  - You therefore get all the installs from the base layer image)
- The `maven:3.5.3-jdk-8-alpine` stage is the base image for the first build, it is named BUILD. And is used to build a fat jar for the application. 
- The second`FROM openjdk:8-jre-alpine` is the final base image for the build. The jar file generated in the first stage is copied to this stage using `COPY --from=BUILD`
- `EXPOSE` instruction tells Docker port 8080 port can be exposed outside the container.
- `COPY --from=BUILD` copies the jar from previous BUILD image layer to app.jar on our final image. 
- `ENTRYPOINT` is the command run on the container when it first starts up. As this is Java app, packaged as a jar. We run the java command `java-jar app.jar`

**Build Docker image and Run it**

- Build the Docker image `docker build -t melissapalmer/docker2helm:latest .` 
  - which will make it available in your local Docker registry.
  - `-t` flag gives the image a name
  - the last parameter `.` specifys the directory to fine the Dockerfile (in this case the current directory)
- You can list the available images in your local docker registry using:  `docker images`
- To now create a container using this image, run the command `docker run -d -p 8080:8080 -t melissapalmer/docker2helm`
  - `-p` flag tells docker to expose the container’s port 8080 (on the right of the colon) on the host’s port 8080 (on the left, our machine). 
- See running Docker container `docker ps`
- Checkout the logs at `docker logs -f <container_id>`
- Stop/Remove container `sudo docker rm <container_id> --force`

Again go to http://localhost:8080/hello to see a hello message, note that the IP address will be different. This is because it is now coming from an application deployed inside a docker container. (Each container gets its own, new IP assigned inside the Docker network.)

# 03-docker-compose

## Prerequisites

**Docker Compose:** 1.17.1		Install Instructions: `sudo apt  install docker-compose`

- Docker

Introduce postgres db instead of using h2

- `sudo docker-compose -f docker-compose.yml up`
  - make sure you have build your own image before running the above ie: `docker build -t melissapalmer/docker2helm:latest .`

sudo docker system prune --volumes

# 04-helm

## Prerequisites

**Minikube**: v0.30.0		Install Instructions at: https://github.com/kubernetes/minikube
**VitualBox:** 				Install Instructions at: https://www.virtualbox.org/wiki/Linux_Downloads
**Helm:** v2.11.0			Install Instructions at: https://docs.helm.sh/using_helm/#installing-helm
**Kubectl**: v1.10.0			Install Instructions at: https://kubernetes.io/docs/tasks/tools/install-kubectl/

Steps

- ```
  helm init
  ```

- `helm create docker-2-helm`

  - customise the chart to include configuration.yrml and .. add volumn to deployment

- helm install --name docker-2-helm ./helm-chart/docker-2-helm

- hosts file entry

- https://github.com/helm/charts/tree/master/stable/postgresql

- `watch kubectl get pods`
- `watch kubectl get ingresses`
- `watch kubectl get services`
- `watch kubectl get pvc`

# 06-helm parent chart

# Available Endpoints on the app include: 

- http://localhost:8080/hello
- http://localhost:8080/actuator
- http://localhost:8080/actuator/health

As usual, the source code for this blog is on [GitHub](https://github.com/melissapalmer/basic-java-app-2-helm)

# References

- [Spring Boot with Docker](https://spring.io/guides/gs/spring-boot-docker/) from Spring.io
- [Dockerize a Spring Boot application](https://thepracticaldeveloper.com/2017/12/11/dockerize-spring-boot/) from The Practical Developer
- [Building thin Docker images using multi-stage build for your java apps!](https://aboullaite.me/multi-stage-docker-java/) from Mohammed Aboullaite