#!/usr/bin/env bash
set -euo pipefail

sudo iptables -N DOCKER-USER 2>/dev/null || true

sudo iptables -C DOCKER-USER -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT 2>/dev/null || \
sudo iptables -I DOCKER-USER 1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

sudo iptables -C DOCKER-USER -i wg0 -p tcp --dport 80 -j ACCEPT 2>/dev/null || \
sudo iptables -I DOCKER-USER 2 -i wg0 -p tcp --dport 80 -j ACCEPT

sudo iptables -C DOCKER-USER -i wg0 -p tcp --dport 8404 -j ACCEPT 2>/dev/null || \
sudo iptables -I DOCKER-USER 3 -i wg0 -p tcp --dport 8404 -j ACCEPT

sudo iptables -C DOCKER-USER ! -i wg0 -p tcp --dport 80 -j DROP 2>/dev/null || \
sudo iptables -I DOCKER-USER 4 ! -i wg0 -p tcp --dport 80 -j DROP

sudo iptables -C DOCKER-USER ! -i wg0 -p tcp --dport 8404 -j DROP 2>/dev/null || \
sudo iptables -I DOCKER-USER 5 ! -i wg0 -p tcp --dport 8404 -j DROP

sudo iptables -C DOCKER-USER -j RETURN 2>/dev/null || \
sudo iptables -A DOCKER-USER -j RETURN

sudo iptables -S DOCKER-USER
