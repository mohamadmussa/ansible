# Dockerfile für ansible mit spezifischen Collections

# =============================================
# Stufe 1: Build-Umgebung (builder)
# =============================================
FROM python:3.11-alpine AS builder

WORKDIR /app

# KORREKTUR: Verwende eine gültige ansible-core Version
ARG ANSIBLE_VERSION="2.19.3"

RUN apk add --no-cache \
    build-base \
    libffi-dev \
    openssl-dev \
    cargo \
    sshpass \
    openssh-client

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Installiere die gewünschte ansible-core Version
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir "ansible-core==${ANSIBLE_VERSION}"

COPY requirements.yml .

# Installiere die Collections
RUN ansible-galaxy collection install -r requirements.yml -p /opt/venv/lib/python3.11/site-packages/ansible_collections

# =============================================
# Stufe 2: Finales, schlankes Image
# =============================================
FROM alpine:3.19

LABEL org.opencontainers.image.authors="Mohamad Mussa" \
      org.opencontainers.image.title="Ansible CI Image" \
      org.opencontainers.image.description="Schlankes Alpine-Image mit Ansible, Hetzner Cloud und Docker Collections für CI/CD."

RUN apk add --no-cache python3 sshpass openssh-client

COPY --from=builder /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /ansible

CMD ["ansible", "--version"]
