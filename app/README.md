# Access Portal application

## Local development

Requirements: JDK 21, Maven 3.9 or newer, Docker Desktop with Compose, and Git Bash or another Bash shell.

From the repository root:

1. Run `cp .env.example .env`.
2. Edit `.env` and replace both password placeholders with different, long local-only values.
3. Run `bash scripts/run-local.sh`.
4. Open `http://localhost:8080`, create an account, then sign in.

The script starts MySQL and launches the app with Maven. The database port is bound to `127.0.0.1`; it is not published on other network interfaces. Flyway creates the authentication tables when the application starts.

Stop the application with `Ctrl+C`. Stop MySQL with `docker compose down`. To also remove the local database volume and its data, run `docker compose down --volumes` from the repository root.

The `.env` file is ignored by Git. Never commit it or reuse these local credentials in AWS.

## Run the container image locally

The multi-stage Dockerfile builds the Java 21 application and copies only the packaged JAR into a small Java runtime image. The final image runs as an unprivileged user. Docker Compose also makes the container filesystem read-only, drops Linux capabilities, and binds the web port to localhost.

Create and edit `.env` as described above, then build and start the image with its MySQL dependency:

```bash
docker compose --profile container up --build
```

Open `http://localhost:8080`. Stop the services with `Ctrl+C`, then run `docker compose down` from the repository root. Add `--volumes` only if you intend to delete the local database data.

To scan the locally built image with Trivy, build it without starting the services and run the scan script:

```bash
docker compose --profile container build access-portal
bash scripts/scan-image.sh
```

Trivy reports HIGH and CRITICAL OS-package and application-library vulnerabilities and returns a failure status when it finds any. Review each finding, update the affected base image or dependency, rebuild, and scan again. Install Trivy using its [official installation guide](https://trivy.dev/latest/getting-started/installation/). The image packaging build skips Maven tests; automated tests and CI gates are a later milestone.
