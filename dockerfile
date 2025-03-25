# ---- Stage 1: Build JAR using Maven ----
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom.xml and download dependencies (cache layer)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code and build the JAR
COPY src/ src/
RUN mvn -B package --file pom.xml

# ---- Stage 2: Run Java App ----
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Run the Java application
CMD ["java", "-jar", "app.jar"]

