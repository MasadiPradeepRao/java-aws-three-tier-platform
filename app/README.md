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
