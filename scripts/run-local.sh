#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
env_file="$project_root/.env"

if [[ ! -f "$env_file" ]]; then
  cp "$project_root/.env.example" "$env_file"
  printf 'Created .env from .env.example. Set unique local passwords, then run this script again.\n'
  exit 1
fi

while IFS='=' read -r name value || [[ -n "$name" ]]; do
  name="${name%$'\r'}"
  value="${value%$'\r'}"
  case "$name" in
    ''|'#'*) continue ;;
    DB_URL|DB_USERNAME|DB_PASSWORD|MYSQL_ROOT_PASSWORD) export "$name=$value" ;;
    *) printf 'Unexpected variable in .env: %s\n' "$name" >&2; exit 1 ;;
  esac
done < "$env_file"

docker compose --env-file "$env_file" --file "$project_root/compose.yaml" up -d --wait --wait-timeout 120 mysql
cd "$project_root/app"
mvn spring-boot:run
