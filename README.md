# Dockerizing a Spring Boot Application

In this post I will go from a basic Spring Boot application running locally on your own PC to 



running via standard Java command to deploying it into a Kubernetes cluster using Helm package manager. 



- [Docker](https://www.docker.com/) 
- [Kubernetes](https://kubernetes.io/) (commonly known as K8s) is an open-source container-orchestration system for automating deployment, scaling and management of containerized applications.

- [Helm](https://docs.helm.sh/) is a package manager for K8s, it simplifies the installation of an application and its dependencies into a K8s cluster.



Basic hello world rest api with /hello which queries a DB for greetings

# 01-Create a Spring Boot Rest API

For this step, I have assumed prior knowledge of Spring Boot, Maven and creating Restful APIs. If not checkout the following Spring.io guides: [Building a RESTful Web Service](https://spring.io/guides/gs/rest-service/), [Building REST services with Spring](https://spring.io/guides/tutorials/bookmarks/), [Accessing JPA Data with REST](https://spring.io/guides/gs/accessing-data-rest/)

You can also grab the code in my repo, on the 01-springboot-app branch in [GitHub](https://github.com/melissapalmer/basic-java-app-2-helm/tree/01-springboot-app)

**This application includes:** 

- An endpoint `/hello` that'll respond with various greetings text from a DB. 
- Spring Actuator: which exposes health endpoints that will be used later on 

**Few things to notice**

- application.yml includes the setting `spring.datasource.platform=h2` Spring in turn knows to use the  `data-h2.sql` file to initialise the h2 DB on start up. 
- I have done this so that later, we can initialise the 'real' DB in other ways. It will help see how a 'real' DB is used vs. the H2 in memory DB.

**Compiling and Running the app** 

- Build Using `./mvnw clean package`
- Run Using `java -jar target/docker-2-helm.jar` or `./mvnw spring-boot:run`

Go to http://localhost:8080/hello to see a hello message. 
Also test out the Spring Actuator endpoints: http://localhost:8080/actuator and http://localhost:8080/actuator/health



**So far we have done nothing with Docker**, however it is important to understand, that we've: 

- We've built and run the application locally: **using a pre-installed version** of Java &/or Maven. 
- If we were to hand this over to the an OPs team at this point: 
  - we'd need to specify to them what version of Java is needed on the machine it'll be running on 

# **02-Containerize It**

**Prerequisites**

- [Docker](https://docs.docker.com/v17.09/engine/installation/linux/docker-ce/ubuntu/)

This step takes the Spring Boot application and creates a Docker image. 

- Build the Docker image `docker build -t melissapalmer/docker2helm:latest .`
- Check its there `docker images`
- Run the docker image .. in a container `docker run -d -p 8080:8080 -t melissapalmer/docker2helm`
- See running Docker container `docker ps`
- Checkout the logs at `docker logs -f <container_id>`
- Stop/Remove container `sudo docker rm <container_id> --force`

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