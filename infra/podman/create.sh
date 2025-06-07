#!/bin/bash
set -e

# 載入 default.env，export 所有變數 or source "$(dirname "$0")/.env"
set -a
source "local.env"
set +a

# 建立 volume（不存在時才建）
for vol in "$POSTGRES_VOLUME" "$REDIS_VOLUME" "$N8N_VOLUME"; do
  if ! podman volume ls --format "{{.Name}}" | grep -q "^${vol}$"; then
    echo "🔄 Creating volume $vol ..."
    podman volume create "$vol"
  else
    echo "✅ Volume $vol already exists."
  fi
done

# 建立網路（不存在時才建）
if ! podman network ls --format "{{.Name}}" | grep -q "^${N8N_NETWORK}$"; then
  echo "🔄 Creating network $N8N_NETWORK ..."
  podman network create "$N8N_NETWORK"
else
  echo "✅ Network $N8N_NETWORK already exists."
fi

# PostgreSQL
if ! podman ps --format "{{.Names}}" | grep -q "^${N8N_POSTGRES_CONTAINER}$"; then
  if podman ps -a --format "{{.Names}}" | grep -q "^${N8N_POSTGRES_CONTAINER}$"; then
    echo "🔄 Starting existing PostgreSQL container..."
    podman start "$N8N_POSTGRES_CONTAINER"
  else
    echo "🔄 Creating new PostgreSQL container..."
    podman run -d --name "$N8N_POSTGRES_CONTAINER" \
      --network "$N8N_NETWORK" \
      -e POSTGRES_USER="$DB_USER" \
      -e POSTGRES_PASSWORD="$DB_PASSWORD" \
      -e POSTGRES_DB="$DB_NAME" \
      -v "$POSTGRES_VOLUME:/var/lib/postgresql/data" \
      docker.io/library/postgres:15
  fi
  echo "🔄 Waiting 5 seconds for PostgreSQL to initialize..."
  sleep 5
else
  echo "✅ PostgreSQL is already running."
fi

# Redis
if ! podman ps --format "{{.Names}}" | grep -q "^${N8N_REDIS_CONTAINER}$"; then
  if podman ps -a --format "{{.Names}}" | grep -q "^${N8N_REDIS_CONTAINER}$"; then
    echo "🔄 Starting existing Redis container..."
    podman start "$N8N_REDIS_CONTAINER"
  else
    echo "🔄 Creating new Redis container..."
    podman run -d --name "$N8N_REDIS_CONTAINER" \
      --network "$N8N_NETWORK" \
      -v "$REDIS_VOLUME:/data" \
      docker.io/library/redis:latest
  fi
else
  echo "✅ Redis is already running."
fi

# n8n Master
if ! podman ps --format "{{.Names}}" | grep -q "^${N8N_MASTER_CONTAINER}$"; then
  if podman ps -a --format "{{.Names}}" | grep -q "^${N8N_MASTER_CONTAINER}$"; then
    echo "🔄 Starting existing n8n Master container..."
    podman start "$N8N_MASTER_CONTAINER"
  else
    echo "🔄 Creating new n8n Master container..."
    podman run -d --name "$N8N_MASTER_CONTAINER" \
      --network "$N8N_NETWORK" \
      -p "$N8N_PORT:$N8N_PORT" \
      -v "$N8N_VOLUME:/home/node/.n8n" \
      -e DB_TYPE=postgresdb \
      -e DB_POSTGRESDB_HOST="$N8N_POSTGRES_CONTAINER" \
      -e DB_POSTGRESDB_PORT="$N8N_POSTGRES_PORT" \
      -e DB_POSTGRESDB_DATABASE="$DB_NAME" \
      -e DB_POSTGRESDB_USER="$DB_USER" \
      -e DB_POSTGRESDB_PASSWORD="$DB_PASSWORD" \
      -e N8N_HOST="localhost" \
      -e N8N_PORT=$N8N_PORT \
      -e N8N_PROTOCOL=http \
      -e N8N_EDITOR_BASE_URL="$N8N_BASE_URL" \
      -e WEBHOOK_URL="$N8N_BASE_URL" \
      -e GENERIC_TIMEZONE="Asia/Taipei" \
      -e N8N_HIRING_BANNER_ENABLED=false \
      -e N8N_LOG_LEVEL=info \
      docker.io/n8nio/n8n:latest
  fi
else
  echo "✅ n8n Master is already running."
fi

echo "✅ n8n cluster has been started! Access at: $N8N_BASE_URL"