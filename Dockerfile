# Step : Build image
FROM maven:3.5.3-jdk-8-alpine as BUILD
WORKDIR /build
COPY pom.xml .
# get all the downloads out of the way
# mvn <maven-plugin-name>:help caches maven specific dependencies to image
# mvn dependency:go-offline caches build depencencies to image
RUN mvn clean
RUN mvn compiler:help jar:help resources:help surefire:help clean:help install:help deploy:help site:help dependency:help javadoc:help spring-boot:help
RUN mvn dependency:go-offline
COPY src/ /build/src/
RUN mvn package

# Step : Package image
FROM openjdk:8-jre-alpine as APP
EXPOSE 8080
COPY --from=BUILD /build/target/docker-2-helm.jar app.jar
#To reduce Tomcat startup time we added a system property pointing to "/dev/urandom" as a source of entropy.
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]