# Dockerfile für ansible mit ENTRYPOINT

# ... (Stufe 1 'builder' bleibt unverändert) ...
# =============================================
# Stufe 1: Build-Umgebung (builder)
# =============================================
FROM python:3.11-alpine AS builder
WORKDIR /app
ARG ANSIBLE_VERSION="2.19.3"
RUN apk add --no-cache build-base libffi-dev openssl-dev cargo sshpass openssh-client
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir "ansible-core==${ANSIBLE_VERSION}"
COPY requirements.yml .
RUN ansible-galaxy collection install -r requirements.yml -p /opt/venv/lib/python3.11/site-packages/ansible_collections

# =============================================
# Stufe 2: Finales, schlankes Image
# =============================================
FROM alpine:3.19

LABEL org.opencontainers.image.authors="Mohamad Mussa" \
      org.opencontainers.image.title="Ansible CI Image"

RUN apk add --no-cache python3 sshpass openssh-client

COPY --from=builder /opt/venv /opt/venv

# --- NEUE SCHRITTE ---
# Kopiere das Entrypoint-Skript in das Image
COPY docker-entrypoint.sh /usr/local/bin/
# Setze das Entrypoint-Skript
ENTRYPOINT ["docker-entrypoint.sh"]
# --------------------

WORKDIR /ansible

# Der CMD wird jetzt an den ENTRYPOINT übergeben
CMD ["ansible", "--version"]
