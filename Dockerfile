FROM openjdk:8
CMD ["echo" , "hello Sudeepthi"]
RUN mkdir rock
WORKDIR /rock
ADD target/rps.war rps.war
EXPOSE 8083
ENTRYPOINT ["java", "-jar", "rps.war"]
