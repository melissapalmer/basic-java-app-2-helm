# docker-2-helm
Basic hello world rest api with /hello which queries a DB for greetings

# 01-springboot-rest-api

This step creates a basic Spring Boot Restful API. Uses Maven to create the build artifact (jar) which we can then run and validate a couple of endpoints. 

- Build Using `./mvnw clean package`

- Run `java -jar target/docker-2-helm.jar` or `./mvnw spring-boot:run`

# **02-springboot-2-docker**

This step takes the Spring Boot application and creates a Docker image. 

- Build the Docker image `docker build -t melissapalmer/docker2helm:latest .`
- Check its there `docker images`
- Run the docker image .. in a container `docker run -d -p 8080:8080 -t melissapalmer/docker2helm`
- See running Docker container `docker ps`
- Checkout the logs at `docker logs -f <container_id>`
- Stop/Remove container `sudo docker rm <container_id> --force`

# 03-docker-compose

- introduce postgres db instead of using h2
- `sudo docker-compose -f docker-compose.yml up`

# 04-k8s

# 05-helm

- https://github.com/helm/charts/tree/master/stable/postgresql

06-helm parent chart

# Available Endpoints on the app include: 

- http://localhost:8080/hello
- http://localhost:8080/actuator
- http://localhost:8080/actuator/health

