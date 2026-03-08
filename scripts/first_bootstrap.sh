#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="/home/mgermano/project"

cd "$PROJECT_DIR"

echo "==> Subindo base"
docker compose up -d postgres wireguard

echo "==> Aplicando schema"
docker compose run --rm backend-migrate

echo "==> Rodando seed inicial"
docker compose run --rm backend-seed

echo "==> Subindo aplicação"
docker compose up -d --build --scale backend=3 backend frontend haproxy

echo "==> Aplicando regras de firewall Docker"
sudo /home/mgermano/project/scripts/apply_docker_user_rules.sh

echo "==> Estado final"
docker compose ps
