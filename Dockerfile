#git
FROM alpine/git as repo

MAINTAINER sudeepthi516@gmail.com

WORKDIR /rock
RUN git clone https://github.com/deepuchakram/rock.git

#Maven
FROM Maven-jdk-8-alpine as build
WORKDIR /rock
COPY --from=repo /rock/rps  /rock
RUN mvn install

#Nexus




#Tomcat
FROM tomcat:8.0.20-jre8
COPY --from=build /rock/target/rps*.war /opt/apache-tomcat-8.5.35/webapps/rps.war
