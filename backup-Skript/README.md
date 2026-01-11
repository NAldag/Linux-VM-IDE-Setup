## Backup & Recovery

Gesichert werden:

- ~/projects
- Relevante Benutzerkonfigurationen
- ~/venv
- Docker-Konfigurationen

### Backup-Skript

~/backup_vm.sh

Eigenschaften:

- Bash-Skript
- Nicht interaktiv
- Absolutpfade (wichtig für systemd)

tar für:
archivierte Snapshots (zeitgestempelt)

### Strategie

- Tar-Archive
- Aufbewahrung: 4 Wochen
- Ziel: Externes Backup Ziel (Hostseitig)

### systemd Service

Datei:
/system/backup-vm.service
type=oneshot
ExecStart=/system/backup_vm.sh
Kein Dauerprozess
sichtbar mit systemctl status

### Systemd Timer

Datei:
/system/backup-vm.timer

Funktion:

- Zeitgesteuerter Start des Services
- Entkoppelt Zeitlogik vom Skript
Aktivierung:

```bash

systemctl daemon-reload
systemctl enable --now backup-vm.timer

```

### Kontrollmechanismen

- systemctl status backup-vm.service
- systemctl list-timers
