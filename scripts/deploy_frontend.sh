#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="/home/mgermano/project"
LOCK_FILE="/tmp/siga-deploy.lock"

exec 9>"$LOCK_FILE"
flock 9

cd "$PROJECT_DIR"

echo "==> Garantindo base"
docker compose up -d postgres wireguard

echo "==> Atualizando frontend"
docker compose up -d --build --no-deps frontend

echo "==> Recriando HAProxy somente se necessário"
docker compose up -d --force-recreate --no-deps haproxy

echo "==> Reaplicando regras de firewall"
sudo /home/mgermano/project/scripts/apply_docker_user_rules.sh

echo "==> Estado final"
docker compose ps
