# docker-2-helm
Basic hello world rest api with /hello which queries a DB for greetings

# 01-springboot-rest-api

**Prerequisites**

- Java

This step creates a basic Spring Boot Restful API. Uses Maven to create the build artifact (jar) which we can then run and validate a couple of endpoints. 

- Build Using `./mvnw clean package`

- Run `java -jar target/docker-2-helm.jar` or `./mvnw spring-boot:run`

# **02-springboot-2-docker**

**Prerequisites**

- Docker

This step takes the Spring Boot application and creates a Docker image. 

- Build the Docker image `docker build -t melissapalmer/docker2helm:latest .`
- Check its there `docker images`
- Run the docker image .. in a container `docker run -d -p 8080:8080 -t melissapalmer/docker2helm`
- See running Docker container `docker ps`
- Checkout the logs at `docker logs -f <container_id>`
- Stop/Remove container `sudo docker rm <container_id> --force`

# 03-docker-compose

**Prerequisites**

- Docker, Docker Compose

Introduce postgres db instead of using h2

- `sudo docker-compose -f docker-compose.yml up`
  - make sure you have build your own image before running the above ie: `docker build -t melissapalmer/docker2helm:latest .`

sudo docker system prune --volumes

# 04-helm

**Prerequisites**

- minikube, helm

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

06-helm parent chart

# Available Endpoints on the app include: 

- http://localhost:8080/hello
- http://localhost:8080/actuator
- http://localhost:8080/actuator/health

