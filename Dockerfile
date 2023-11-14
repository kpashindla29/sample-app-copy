FROM ubuntu:latest

LABEL maintainer="Kishore Pashindla <kpashindla@albanybeck.com>"

# Set environment variables
ENV TOMCAT_VERSION 9.0.82
ENV CATALINA_HOME /mnt/c/apache-tomcat-9.0.82
ENV JAVA_HOME /mnt/c/Program Files/Java/jdk-17
ENV PATH $CATALINA_HOME/bin:$PATH

# Install JDK & wget packages.
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openjdk-17-jdk wget

# Install and configure Tomcat.
RUN mkdir $CATALINA_HOME

RUN wget https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tar.gz

RUN cd /tmp && tar xvfz tomcat.tar.gz

RUN cp -Rv /tmp/apache-tomcat-${TOMCAT_VERSION}/* $CATALINA_HOME

RUN rm -rf /tmp/apache-tomcat-${TOMCAT_VERSION}

RUN rm -rf /tmp/tomcat.tar.gz

COPY target/sampleapp.war C:\apache-tomcat-9.0.82\webapps
EXPOSE 8080
#CMD /usr/local/tomcat/bin/catalina.bat run
CMD ["/mnt/c/apache-tomcat-9.0.82/bin/catalina.sh", "run"]
