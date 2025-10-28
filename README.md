# Ansible CI/CD Docker Image

Dieses Repository enthält das `Dockerfile` zur Erstellung eines schlanken, auf Alpine basierenden Docker-Images für Ansible. Es ist für den Einsatz in CI/CD-Pipelines wie GitLab CI optimiert.

Das Image wird automatisch gebaut und ist auf DockerHub verfügbar:
**[mohamadmussa/ansible](https://hub.docker.com/r/mohamadmussa/ansible )**

---

## Features

*   **Schlankes Image**: Basiert auf `alpine:3.19` für eine minimale Größe und schnellere Pipeline-Starts.
*   **Versionierte Software**: Verwendet eine fest definierte Version von `ansible-core` für reproduzierbare Builds.
*   **Multi-Stage Build**: Hält das finale Image sauber und frei von unnötigen Build-Abhängigkeiten.
*   **Vorinstallierte Collections**: Enthält wichtige Ansible-Collections für gängige Automatisierungsaufgaben.

## Enthaltene Software

*   **Basis-Image**: `alpine:3.19`
*   **Ansible Core**: `2.16.5`
*   **Enthaltene Ansible Collections**:
    *   `community.docker` (Version `4.8.1`)
    *   `hetzner.hcloud` (Version `5.4.0`)
    *   `community.library_inventory_filtering_v1` (Version `1.1.4`)

---

## Verwendung

### DockerHub

Das vorgefertigte Image kann direkt von DockerHub bezogen werden.

```sh
# Pull des Images
docker pull mohamadmussa/ansible:latest

# Beispiel-Tag für eine spezifische Version
docker pull mohamadmussa/ansible:2.19.3-alpine3.19-hcloud
```

### Verwendung in GitLab CI

Um dieses Image in einem GitLab-CI-Job zu verwenden, gib es im `image`-Feld an:

```yaml
deploy_job:
  stage: deploy
  image: mohamadmussa/ansible:2.19.3-alpine3.19-hcloud
  
  script:
    - echo "Ansible-Version: $(ansible --version)"
    - echo "Führe Playbook aus..."
    - ansible-playbook -i inventory.yml main.yml
```

### Lokales Bauen

Wenn du das Image selbst bauen oder anpassen möchtest:

1.  Klone das Repository:
    ```sh
    git clone https://github.com/mohamadmussa/ansible.git
    cd ansible
    ```

2.  Passe bei Bedarf die `requirements.yml` an, um Collections hinzuzufügen oder zu entfernen.

3.  Baue das Image:
    ```sh
    # Baue das Image und tagge es
    docker build -t mohamadmussa/ansible:2.16.5-alpine-hcloud .
    ```

4.  (Optional ) Lade es in dein DockerHub-Repository hoch:
    ```sh
    docker login
    docker push mohamadmussa/ansible:2.16.5-alpine-hcloud
    ```
