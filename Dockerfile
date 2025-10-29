# ===================================================================
# FINALES, FUNKTIONIERENDES DOCKERFILE FÜR ANSIBLE
# Single-Stage-Build mit Python-Abhängigkeiten für Collections
# ===================================================================

# Wir starten mit einem Python-fähigen Alpine-Image und bleiben dabei.
FROM python:3.11-alpine3.19

LABEL org.opencontainers.image.authors="Mohamad Mussa" \
      org.opencontainers.image.title="Ansible CI Image" \
      org.opencontainers.image.description="Funktionierendes Alpine-Image mit Ansible 2.19.3 und Collections."

ARG ANSIBLE_VERSION="2.19.3"

# Installiere Build-Tools, dann Ansible, dann entferne die Build-Tools
RUN apk add --no-cache --virtual .build-deps \
    build-base \
    libffi-dev \
    openssl-dev \
    cargo \
    && apk add --no-cache \
    sshpass \
    openssh-client \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir "ansible-core==${ANSIBLE_VERSION}" \
    && apk del .build-deps

# --- NEUER SCHRITT: PYTHON-ABHÄNGIGKEITEN FÜR COLLECTIONS INSTALLIEREN ---
# Kopiere die requirements.txt und installiere die Pakete mit pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# ----------------------------------------------------------------------

# Kopiere die requirements.yml und installiere die Ansible Collections
COPY requirements.yml .
RUN ansible-galaxy collection install -r requirements.yml

# Setze das Arbeitsverzeichnis
WORKDIR /ansible

# Standardbefehl zum Testen
CMD ["ansible", "--version"]
