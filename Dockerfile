FROM ubuntu:latest

LABEL maintainer="Kishore Pashindla <kpashindla@albanybeck.com>"

# Set environment variables
ENV TOMCAT_VERSION 9.0.82
ENV CATALINA_HOME /usr/local/apache-tomcat-9.0.82
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64
ENV PATH $CATALINA_HOME/bin:$PATH

# Install JDK & wget packages.
RUN apt-get update && apt-get install -y openjdk-17-jdk wget

# Install and configure Tomcat.
RUN mkdir -p $CATALINA_HOME \
    && wget https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tar.gz \
    && tar xvfz /tmp/tomcat.tar.gz -C /tmp \
    && cp -Rv /tmp/apache-tomcat-${TOMCAT_VERSION}/* $CATALINA_HOME \
    && rm -rf /tmp/apache-tomcat-${TOMCAT_VERSION} /tmp/tomcat.tar.gz

# Copy your WAR file into the webapps directory
COPY target/sampleapp.war $CATALINA_HOME/webapps/

# Expose port 8080
EXPOSE 8080

# Run Tomcat
CMD ["catalina.sh", "run"]
