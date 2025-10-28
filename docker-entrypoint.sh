#!/bin/sh
set -e

# Aktiviere die virtuelle Python-Umgebung
# Dies stellt sicher, dass der PATH für jeden Befehl korrekt ist
. /opt/venv/bin/activate

# Führe den Befehl aus, der an 'docker run' übergeben wurde
# "$@" repräsentiert alle Argumente, die dem Container übergeben werden
exec "$@"
