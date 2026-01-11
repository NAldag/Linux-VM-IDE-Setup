#!/env/bin/bash
set -e

# ---------------- CONFIG ----------------
DATE=$(date +%F)
HOME_DIR="/home/watumba"

BACKUP_BASE="/mnt/hgfs/VMShare/backups"
ARCHIVE="$BACKUP_BASE/archives"
MIRROR="$BACKUP_BASE/mirror"

# Sicherstellen, dass die Zielordner existieren
mkdir -p "$ARCHIVE"
mkdir -p "$MIRROR/projects" "$MIRROR/ssh" "$MIRROR/venv" "$MIRROR/docker"

# ---------------- TAR.GZ BACKUPS ----------------

# Projekte
if [ -d "$HOME_DIR/projects" ]; then
    tar -czf "$ARCHIVE/projects_$DATE.tar.gz" -C "$HOME_DIR" ./projects
fi

# SSH
if [ -d "$HOME_DIR/.ssh" ]; then
    tar -czf "$ARCHIVE/ssh_$DATE.tar.gz" -C "$HOME_DIR" ./.ssh
fi

# Python venv + requirements.txt
if [ -d "$HOME_DIR/venv" ] || [ -f "$HOME_DIR/projects/requirements.txt" ]; then
    tar -czf "$ARCHIVE/venv_$DATE.tar.gz" -C "$HOME_DIR" venv projects/requirements.txt 2>/dev/null || true
fi

# Docker-compose.yml & .env Dateien
TMP_LIST=$(mktemp)
find "$HOME_DIR/projects" -type f \( -name "docker-compose.yml" -o -name ".env" \) > "$TMP_LIST"
if [ -s "$TMP_LIST" ]; then
    tar -czf "$ARCHIVE/docker_env_$DATE.tar.gz" -T "$TMP_LIST"
fi
rm -f "$TMP_LIST"

# ---------------- ROTATION (4 WOCHEN) ----------------
find "$ARCHIVE" -type f -mtime +28 -delete

