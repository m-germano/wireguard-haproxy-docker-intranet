#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="/home/mgermano/project"
LOCK_FILE="/tmp/siga-deploy.lock"

exec 9>"$LOCK_FILE"
flock 9

cd "$PROJECT_DIR"

echo "==> Garantindo base"
docker compose up -d postgres wireguard

echo "==> Aplicando schema"
docker compose run --rm backend-migrate

echo "==> Limpando réplicas antigas do backend"
docker compose rm -sf backend || true

echo "==> Atualizando backend"
docker compose up -d --build --no-deps --scale backend=3 backend

echo "==> Reaplicando regras de firewall"
sudo /home/mgermano/project/scripts/apply_docker_user_rules.sh

echo "==> Estado final"
docker compose ps
