# Ansible CI/CD Docker Image

Dieses Repository enthält das `Dockerfile` zur Erstellung eines schlanken, auf Alpine basierenden Docker-Images für Ansible. Es ist für den Einsatz in CI/CD-Pipelines wie GitLab CI optimiert und enthält neben Ansible Core auch `ansible-lint` und die Docker-CLI.

Das Image wird automatisch gebaut und ist auf DockerHub verfügbar:
**[mohamadmussa/ansible](https://hub.docker.com/r/mohamadmussa/ansible)**

---

## Features

*   **Schlankes Image**: Basiert auf `python:3.11-alpine` für eine minimale Größe und schnelle Pipeline-Starts.
*   **Versionierte Software**: Verwendet fest definierte Versionen von `ansible-core`, `ansible-lint` und den Collections für reproduzierbare Builds.
*   **CI/CD-optimiert**: Enthält `ansible-lint` für statische Code-Analyse und `docker-cli` für die Interaktion mit Docker-Daemons.
*   **Vorinstallierte Collections**: Wichtige Ansible-Collections für gängige Automatisierungsaufgaben sind bereits enthalten.

## Enthaltene Software

*   **Basis-Image**: `python:3.11-alpine`
*   **Ansible Core**: `2.19.3`
*   **Ansible Lint**: `25.9.2`
*   **Zusätzliche Tools**: `sshpass`, `openssh-client`, `docker-cli`, `docker-compose`, `wireguard-tools`
*   **Enthaltene Ansible Collections**:
    *   `community.docker` (Version `4.8.1`)
    *   `community.general` (Version `11.4.0`)
    *   `community.crypto` (Version `3.0.4`)
    *   `hetzner.hcloud` (Version `5.4.0`)
    *   `community.library_inventory_filtering_v1` (Version `1.1.4`)

---

## Verwendung

### DockerHub

Das vorgefertigte Image kann direkt von DockerHub bezogen werden. Es wird empfohlen, einen spezifischen Tag anstelle von `latest` zu verwenden, um die Reproduzierbarkeit Ihrer Pipelines sicherzustellen.

```sh
# Pull des Images mit einem spezifischen Tag
docker pull mohamadmussa/ansible:2.19.3-alpine3.22
```

### Verwendung in GitLab CI

Um dieses Image in einem GitLab-CI-Job zu verwenden, geben Sie es im `image`-Feld an:

```yaml
lint_and_deploy:
  stage: deploy
  image: mohamadmussa/ansible:2.19.3-alpine3.22
  script:
    - echo "Ansible-Version: $(ansible --version)"
    - echo "Führe Linting für das Playbook aus..."
    - ansible-lint main.yml
    - echo "Führe Playbook aus..."
    - ansible-playbook -i inventory.yml main.yml
```

### Lokales Bauen

Wenn Sie das Image selbst bauen oder anpassen möchten:

1.  **Klone das Repository:**
    ```sh
    git clone https://github.com/mohamadmussa/ansible.git
    cd ansible
    ```

2.  **Passe die Abhängigkeiten an (optional):**
    *   Bearbeite die `requirements.txt`, um Python-Pakete zu ändern.
    *   Bearbeite die `requirements.yml`, um Ansible-Collections anzupassen.

3.  **Baue das Image:**
    ```sh
    # Baue das Image und tagge es
    docker build -t mein-ansible-image:custom .
    ```

4.  **(Optional) Lade es in deine eigene Registry hoch:**
    ```sh
    docker login
    docker push mein-ansible-image:custom
    ```
