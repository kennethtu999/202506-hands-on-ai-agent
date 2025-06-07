#!/bin/bash
set -e

# 載入環境變數
set -a
source "local.env"
set +a

FORCE=false
if [[ "$1" == "--force" ]]; then
  FORCE=true
fi

# 檢查 PostgreSQL container 是否在執行
if ! podman ps --format "{{.Names}}" | grep -q "^${N8N_POSTGRES_CONTAINER}$"; then
  echo "❌ PostgreSQL container $N8N_POSTGRES_CONTAINER is not running."
  exit 1
fi

# 執行 DROP（只在 --force 模式）
if $FORCE; then
  echo "⚠️  Executing DROP statements (force mode)..."
  podman exec -i "$N8N_POSTGRES_CONTAINER" \
    psql -U "$DB_USER" -d "$DB_NAME" <<< "DROP TABLE IF EXISTS prompts, global_vars;"
fi

# 執行 DDL（不含 DROP）
echo "📥 Applying DDL..."
echo "$N8N_INIT_DDL" | podman exec -i "$N8N_POSTGRES_CONTAINER" \
  psql -U "$DB_USER" -d "$DB_NAME"

# 執行 DML
echo "📥 Applying DML..."
echo "$N8N_INIT_DML" | podman exec -i "$N8N_POSTGRES_CONTAINER" \
  psql -U "$DB_USER" -d "$DB_NAME"

echo "✅ DDL and DML applied successfully. (--force=$FORCE)"
