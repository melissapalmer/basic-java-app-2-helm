# 01-springboot-rest-api

This step creates a basic Spring Boot Restful API. Uses Maven to create the build artifact (jar) which we can then run and validate a couple of endpoints. 

- Build Using `./mvnw clean package`

- Run `java -jar target/docker-2-helm-0.0.1-SNAPSHOT.jar`

Available Endpoints on the app include: 

- http://localhost:8080/hello
- http://localhost:8080/actuator
- http://localhost:8080/actuator/health

