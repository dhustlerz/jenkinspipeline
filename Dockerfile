FROM maven:3.5.2-jdk-8-alpine AS MAVEN_TOOL_CHAIN

MAINTAINER jashan (jashan.pahwa007@gmail.com)
COPY pom.xml /tmp/pom.xml
COPY server /tmp/server/
COPY webapp /tmp/webapp/
WORKDIR /tmp/
RUN mvn package


FROM tomcat:9.0-jre8-alpine
COPY --from=MAVEN_TOOL_CHAIN tmp/server/target/server.jar $CATALINA_HOME/webapps/server.jar
COPY --from=MAVEN_TOOL_CHAIN tmp/webapp/target/webapp.war $CATALINA_HOME/webapps/webapp.war
EXPOSE 4040

HEALTHCHECK --interval=1m --timeout=3s CMD wget --quiet --tries=1 --spider http://localhost:8080/wizard/ || exit 1
