#!/bin/bash
set -e

# 載入 local.env
set -a
source "local.env"
set +a

echo "🛑 Stopping and removing containers..."

for container in "$N8N_MASTER_CONTAINER" "$N8N_POSTGRES_CONTAINER" "$N8N_REDIS_CONTAINER"; do
  if podman ps -a --format "{{.Names}}" | grep -q "^${container}$"; then
    echo "🔄 Removing container: $container"
    podman rm -f "$container"
  else
    echo "✅ Container $container does not exist."
  fi
done

echo "🧹 Removing volumes..."

for vol in "$POSTGRES_VOLUME" "$REDIS_VOLUME" "$N8N_VOLUME"; do
  if podman volume ls --format "{{.Name}}" | grep -q "^${vol}$"; then
    echo "🔄 Removing volume: $vol"
    podman volume rm "$vol"
  else
    echo "✅ Volume $vol does not exist."
  fi
done

#echo "🌐 Removing network..."

#if podman network ls --format "{{.Name}}" | grep -q "^${N8N_NETWORK}$"; then
#  echo "🔄 Removing network: $N8N_NETWORK"
#  podman network rm "$N8N_NETWORK"
#else
#  echo "✅ Network $N8N_NETWORK does not exist."
#fi

echo "✅ Cleanup complete."
