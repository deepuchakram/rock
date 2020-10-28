FROM openjdk:8
RUN mkdir rock
WORKDIR /rock
ADD target/rps.war rps.war
EXPOSE 8083
ENTRYPOINT ["java", "-jar", "rps.war"]
