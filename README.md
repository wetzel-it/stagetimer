# StageTimer

Eine umfassende Webanwendung zur Verwaltung und Anzeige von Band-Zeitplänen für Live-Events wie Konzerte und Festivals. Mit SQLite-Datenbank, Band-Logo-Integration, automatischer Historie und CSV-Import/Export.

## Features

### Core-Features
- **Live-Timer-Display**: Öffentliche Anzeige mit Countdown und Fortschrittsbalken
- **Admin-Dashboard**: Verwaltung des Event-Zeitplans mit Echtzeit-Vorschau
- **Echtzeit-Synchronisation**: WebSocket-basierte Updates zwischen Admin und Display
- **SQLite-Datenbank**: Robuste Datenhaltung mit automatischer Backup-Funktion
- **Rollenbasierte Zugriffskontrolle**: 5 Rollen mit feingranularen Berechtigungen
- **Veranstaltungspasswort**: Anonymer Zugang zur Bühnenanzeige für Gäste
- **Responsive Design**: Funktioniert auf Smartphones, Tablets und Desktop-Displays

### Features (v2.3)
- **CLI-Hilfsskript**: Serververwaltung per `stagetimer update/restart/logs/status`
- **Konfigurierbare Abschluss-Anzeige**: Überschrift und Nachricht für das Ende der Veranstaltung im Admin-Panel einstellbar
- **Automatische Ersteinrichtung**: Setup-Seite erscheint beim ersten Start zur Admin-Account-Erstellung
- **Automatischer SECRET_KEY**: Session-Key wird generiert und persistent gespeichert — keine manuelle Konfiguration nötig
- **Docker Named Volumes**: Zuverlässige Datenpersistenz ohne Berechtigungsprobleme
- **Zentrales Datenverzeichnis**: Datenbank, Uploads und Session-Key im `data/`-Verzeichnis

### Features (v2.2)
- **Passwort-Verwaltung**: Benutzer können ihr Passwort selbst ändern
- **Admin Passwort-Reset**: Admins können Passwörter anderer Benutzer zurücksetzen
- **Nachrichten-Vorschau**: Gesendete Nachrichten werden in der Display-Vorschau angezeigt

### Features (v2.1)
- **Rollenbasiertes Berechtigungssystem** mit 5 Rollen:
  - `ViewerStage` - Nur Bühnenanzeige
  - `ViewerBackstage` - Nur Backstage-Anzeige
  - `ViewerTimetable` - Nur Zeitplan-Anzeige
  - `Stagemanager` - Eingeschränkter Admin + alle Viewer-Rechte
  - `Admin` - Vollzugriff auf alle Funktionen
- **Veranstaltungspasswort**: Anonymer Zugang zur Bühnenanzeige
  - Konfigurierbar im Admin-Panel
  - Separater Login-Tab
- **Rollen-Verwaltung**: Klick auf Benutzername im Admin-Panel
- **Geschützte Views**: Alle Seiten erfordern Login

### Features (v2.0)
- **Band-Logos**: Upload und Anzeige von Band-Logos auf der Bühnen-Anzeige
  - Smart Rename: Automatische Übertragung beim Umbenennen von Bands
  - Unterstützte Formate: PNG, JPG, GIF, SVG, WEBP
- **Historie-System**: Automatische Aufzeichnung aller gespielten Sets
  - Geplante vs. tatsächliche Zeiten
  - Soft-Delete Funktion (Einträge bleiben in DB)
  - Export-fähig für Auswertungen
- **CSV-Verwaltung**: Import und Export des gesamten Zeitplans
  - Beispiel-CSV-Download (mit aktuellem Datum)
  - Konflikterkennung beim Upload
  - Bulk-Import für große Events
- **Anleitung/Hilfeseite**: Integrierte Dokumentation aller Features

### Weitere Features
- **Logo-Anpassung**: Upload und Positionierung von Custom-Branding
- **Warnsystem**: Farbcodierte Indikatoren (grün → orange → rot)
- **Wake-Lock**: Verhindert Screen-Sleep auf mobilen Geräten
- **Docker-Ready**: Einfaches Deployment mit Docker und Docker Compose
- **Zeit-Anpassung**: Live-Verlängerung/Verkürzung während des Events
- **Backstage-View**: Kompakte Ansicht für Backstage-Monitore
- **Timetable-View**: Öffentliche Zeitplan-Übersicht

## Technologie-Stack

- **Backend**: Flask 3.0.2, Flask-SocketIO 5.3.6
- **Database**: SQLite3
- **Authentication**: Flask-Login 0.6.3
- **Data Processing**: Pandas 2.2.1
- **Real-time**: Socket.IO (WebSockets)
- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Containerization**: Docker, Docker Compose

## Installation

### Voraussetzungen

- Python 3.12+ oder Docker
- Git

### Option 1: Lokale Installation

1. **Repository klonen**
   ```bash
   git clone <repository-url>
   cd stagetimer
   ```

2. **Virtual Environment erstellen**
   ```bash
   python -m venv venv
   source venv/bin/activate  # Linux/Mac
   venv\Scripts\activate     # Windows
   ```

3. **Dependencies installieren**
   ```bash
   pip install -r requirements.txt
   ```

4. **Anwendung starten**
   ```bash
   python app.py
   ```

5. **Browser öffnen und Admin-Account erstellen**
   - Öffne http://localhost:5000
   - Bei der ersten Installation erscheint automatisch die Setup-Seite
   - Erstelle deinen Admin-Account und wirst automatisch eingeloggt

### Option 2: Docker Installation

1. **Repository klonen**
   ```bash
   git clone <repository-url>
   cd stagetimer
   ```

2. **Container starten**
   ```bash
   docker compose up -d
   ```

3. **Browser öffnen** → http://localhost:5000 → Setup-Seite erscheint automatisch

4. **Nützliche Docker-Befehle**
   ```bash
   docker compose logs -f      # Logs anzeigen
   docker compose down         # Container stoppen
   docker compose restart      # Container neustarten
   ```

   Alle Daten werden im Docker Volume `stagetimer_data` gespeichert (Datenbank, Session-Key, Logos).

## Konfiguration

### Umgebungsvariablen (optional)

**Die Anwendung funktioniert komplett ohne Konfiguration!** Alle Einstellungen haben sinnvolle Standardwerte.

```bash
cp .env.example .env
# Bearbeite .env nach Bedarf
```

| Variable | Standard | Beschreibung |
|----------|----------|--------------|
| `SECRET_KEY` | Auto-generiert | Session-Key (wird automatisch persistent gespeichert) |
| `FLASK_ENV` | `production` | `development` = Debug + Auto-Reload |
| `LOG_LEVEL` | `ERROR` | `ERROR`, `WARNING`, `INFO` oder `DEBUG` |
| `TZ` | `Europe/Berlin` | Zeitzone für korrekte Zeitanzeige |

### Benutzer und Rollen verwalten

**Rollen-Übersicht**:

| Rolle | Stage | Backstage | Timetable | Admin (eingeschränkt) | Admin (voll) |
|-------|:-----:|:---------:|:---------:|:---------------------:|:------------:|
| ViewerStage | X | - | - | - | - |
| ViewerBackstage | - | X | - | - | - |
| ViewerTimetable | - | - | X | - | - |
| Stagemanager | X | X | X | X | - |
| Admin | X | X | X | X | X |

- **Viewer-Rollen** können kombiniert werden (z.B. ViewerStage + ViewerTimetable)
- **Stagemanager** und **Admin** sind exklusiv

**Veranstaltungspasswort**: Ermöglicht Gästen Zugang zur Bühnenanzeige ohne Account — einstellbar im Admin-Panel.

### Zeitplan konfigurieren

**Option 1: Admin-Panel** (empfohlen) — Bands direkt in der UI anlegen und bearbeiten

**Option 2: CSV-Import**

```csv
date,band,start,end
2026-02-02,Band Name,19:00,20:00
2026-02-02,Next Band,20:30,22:00
```

## CLI-Hilfsskript

Das enthaltene `stagetimer.sh` ermöglicht einfache Serververwaltung per Kommandozeile.

### Installation (einmalig auf dem Server)

```bash
cp /opt/stagetimer/stagetimer.sh /usr/local/bin/stagetimer
chmod +x /usr/local/bin/stagetimer
```

### Verfügbare Befehle

| Befehl | Beschreibung |
|--------|--------------|
| `stagetimer update` | Git Pull + Docker Rebuild + Neustart |
| `stagetimer restart` | Container neu starten |
| `stagetimer start` | Container starten |
| `stagetimer stop` | Container stoppen |
| `stagetimer logs` | Live-Logs anzeigen |
| `stagetimer status` | Container-Status anzeigen |

## Sicherheit

1. **HTTPS**: In Produktion immer HTTPS verwenden (z.B. nginx + Let's Encrypt)
2. **Firewall**: Port 5000 nur für autorisierte IPs freigeben
3. **Passwort-Hashing**: scrypt mit automatischer Salt-Generierung

### Nginx Reverse Proxy

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Entwicklung

### Code-Struktur

```
stagetimer/
├── app.py                      # Hauptanwendung (Flask)
├── database.py                 # Datenbank-Management (SQLite)
├── requirements.txt            # Python-Dependencies
├── Dockerfile                  # Docker-Image
├── docker-compose.yml          # Docker-Compose-Konfiguration
├── .env.example                # Umgebungsvariablen-Vorlage
├── static/
│   ├── style.css
│   ├── script.js
│   ├── socket.io.js
│   └── uploads/
│       └── band_logos/
└── templates/
    ├── index.html              # Stage View
    ├── backstage.html          # Backstage View
    ├── timetable.html          # Timetable View
    ├── admin.html              # Admin-Dashboard
    ├── login.html              # Login-Seite
    ├── setup.html              # Ersteinrichtung
    └── guide.html              # Anleitung
```

## API

### REST Endpoints

| Route | Methode | Beschreibung | Berechtigung |
|-------|---------|--------------|--------------|
| `/` oder `/stage` | GET | Stage View | ViewerStage+ |
| `/backstage` | GET | Backstage View | ViewerBackstage+ |
| `/timetable` | GET | Timetable View | ViewerTimetable+ |
| `/admin` | GET/POST | Admin-Dashboard | Stagemanager+ |
| `/guide` | GET | Anleitung | Login |
| `/setup` | GET/POST | Ersteinrichtung | Nur ohne User |
| `/login` | GET/POST | Login | - |
| `/logout` | GET | Logout | Login |
| `/status` | GET | Timer-Status (JSON) | Öffentlich |
| `/api/user/<username>/roles` | GET/POST | Rollen verwalten | Admin |
| `/api/settings/event-password` | GET/POST | Veranstaltungspasswort | Admin |

### WebSocket Events

**`time_update`** (vom Server):
```javascript
{
  status: "playing|waiting|finished",
  band: "Band Name",
  remaining: 2700,
  total_duration: 3600,
  warn_orange: 5,
  warn_red: 1,
  band_logo: "filename.png",
  next_band: { band: "...", start: "20:00", countdown: 3600 }
}
```

## Versionshistorie

Die vollständige Versionshistorie findest du in der [CHANGELOG.md](CHANGELOG.md).

**Aktuelle Version:** 2.3.4

## Lizenz

Dieses Projekt ist lizenziert unter der [GNU Affero General Public License v3.0 (AGPL-3.0)](LICENSE).

## Support

Bei Fragen oder Problemen erstelle bitte ein Issue im GitHub-Repository.

## Credits

**Entwickler:** André Wetzel  
**Projekt:** StageTimer - Webbasiertes Countdown-System für Live-Events  
**Technologie:** Flask, Socket.IO, SQLite, Docker
