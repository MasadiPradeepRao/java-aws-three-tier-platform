FROM maven:3.9.16-eclipse-temurin-21-alpine AS build

WORKDIR /workspace

COPY app/pom.xml ./pom.xml
RUN mvn --batch-mode --no-transfer-progress -DskipTests dependency:go-offline

COPY app/src ./src
RUN mvn --batch-mode --no-transfer-progress -DskipTests package

FROM eclipse-temurin:21-jre-alpine-3.24 AS runtime

RUN addgroup -S --gid 10001 app \
    && adduser -S --uid 10001 --ingroup app app

WORKDIR /app
COPY --from=build --chown=10001:10001 /workspace/target/access-portal-0.1.0-SNAPSHOT.jar /app/app.jar

USER 10001:10001
EXPOSE 8080

ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75.0", "-jar", "/app/app.jar"]
