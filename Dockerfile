FROM openjdk:8-jdk-alpine
RUN apk add --update \
    curl \
    && rm -rf /var/cache/apk/*
ARG JAR_FILE=target/spring-boot-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","-Dspring.config.location=etc/config/application.properties","/app.jar"]