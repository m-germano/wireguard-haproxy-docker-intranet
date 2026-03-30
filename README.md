# Infraestrutura de Aplicação com GCP, WireGuard, HAProxy e Docker Compose

Projeto de infraestrutura e deploy de aplicação em uma **VM Ubuntu 22.04 no Google Cloud Platform (GCP)**, com acesso seguro via **WireGuard VPN**, balanceamento de carga com **HAProxy** e serviços executando em **containers Docker**.

---

## Visão geral

A aplicação é hospedada em uma única VM no GCP e pode ser acessada de forma segura por meio de uma VPN WireGuard.  
O tráfego entra pela VM, passa pelo **HAProxy**, que atua como **reverse proxy** e **load balancer**, e então é encaminhado para os serviços internos da aplicação.

A arquitetura inclui:

- **WireGuard VPN** para acesso seguro
- **HAProxy** para roteamento e balanceamento
- **Frontend** exposto internamente
- **3 instâncias de backend** (`api1`, `api2`, `api3`) com **round robin**
- **PostgreSQL** como banco de dados
- **Docker Compose** para orquestração dos serviços

---

## Diagrama da arquitetura


![diagrama](https://github.com/user-attachments/assets/8070fd22-11fb-464a-a6a9-043b1d745b2c)



---

## Arquitetura resumida

Fluxo principal da aplicação:

1. O cliente se conecta à **VPN WireGuard**
2. O acesso entra pela VM no **GCP**
3. O **HAProxy** recebe as requisições
4. O HAProxy roteia:
   - `/` para o **Frontend**
   - `/api` para o pool de backends
5. O balanceamento entre `api1`, `api2` e `api3` é feito em **round robin**
6. As APIs se conectam ao **PostgreSQL**

---

## Informações de rede

- **IP público da VM:** `34.30.64.67`
- **VPN:** `WireGuard`
- **Porta da VPN:** `51820/UDP`
- **SSH / SFTP:** `22/TCP`

> O acesso principal à aplicação ocorre **somente via VPN**.

---

## Estrutura dos serviços

- **HAProxy**
  - Reverse proxy
  - Load balancer
- **Frontend**
- **Backend**
  - `api1`
  - `api2`
  - `api3`
- **PostgreSQL**

Todos os serviços da aplicação rodam em containers dentro do mesmo host Docker.

---

## Tecnologias utilizadas

- **Google Cloud Platform (GCP)**
- **Ubuntu 22.04**
- **Docker**
- **Docker Compose**
- **HAProxy**
- **WireGuard**
- **PostgreSQL**
- **TypeScript**

---

## Objetivo do projeto

Este projeto foi desenvolvido para demonstrar uma arquitetura simples e funcional de deploy, com foco em:

- acesso seguro via VPN
- roteamento interno centralizado
- balanceamento de carga entre múltiplas instâncias de API
- organização de serviços com Docker Compose
- execução em ambiente cloud com GCP
