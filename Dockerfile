FROM openjdk:8
RUN mkdir rock
WORKDIR /rock
ADD target/rps.jar rps.jar
EXPOSE 8083
ENTRYPOINT ["java", "-jar", "rps.jar"]
