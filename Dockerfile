# Use an official Maven image to build the application
FROM maven:3.8.5-openjdk-17 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml file and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the application code
COPY src ./src

# Build the application
RUN mvn clean install -DskipTests

# Use an official Tomcat runtime as a parent image for deployment
FROM tomcat:8.5.47-jdk8-openjdk

# Copy the WAR file from the Maven build stage to the Tomcat webapps directory
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/

# Expose port 8082 (default port for Tomcat)
EXPOSE 8082

# Start Tomcat when the container launches
CMD ["catalina.sh", "run"]
