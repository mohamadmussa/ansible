# ===================================================================
# FUNKTIONIERENDES DOCKERFILE FÜR ANSIBLE + LINTING
# Single-Stage-Build mit Python-Abhängigkeiten für Collections
# ===================================================================

# Wir starten mit einem Python-fähigen Alpine-Image und bleiben dabei.
FROM python:3.11-alpine3.22

LABEL org.opencontainers.image.authors="Mohamad Mussa" \
      org.opencontainers.image.title="Ansible CI Image" \
      org.opencontainers.image.description="Funktionierendes Alpine-Image mit Ansible, Collections, ansible-lint und Docker-CLI."

# Installiere zuerst alle System-Abhängigkeiten in einem Schritt.
RUN apk add --no-cache --virtual .build-deps \
    build-base \
    libffi-dev \
    openssl-dev \
    cargo \
    && apk add --no-cache \
    sshpass \
    openssh-client \
    docker-cli \
    docker-compose \
    wireguard-tools

# Installiere alle Python-Pakete in einem einzigen RUN-Befehl, um die Anzahl der Layer zu reduzieren.
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Kopiere die requirements.yml und installiere die Ansible Collections
COPY requirements.yml .
RUN ansible-galaxy collection install -r requirements.yml

# Bereinige die Build-Abhängigkeiten in einem separaten, letzten Schritt.
RUN apk del .build-deps

# Setze das Arbeitsverzeichnis
WORKDIR /ansible

# Standardbefehl zum Testen
CMD ["ansible", "--version"]
