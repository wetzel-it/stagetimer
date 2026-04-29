#!/bin/bash

INSTALL_DIR="/opt/stagetimer"

case "$1" in
  update)
    echo "Stagetimer wird aktualisiert..."
    cd "$INSTALL_DIR" || { echo "Fehler: $INSTALL_DIR nicht gefunden"; exit 1; }
    git pull
    docker compose up -d --build
    echo "Update abgeschlossen."
    ;;
  restart)
    docker compose -f "$INSTALL_DIR/docker-compose.yml" restart
    ;;
  stop)
    docker compose -f "$INSTALL_DIR/docker-compose.yml" down
    ;;
  start)
    docker compose -f "$INSTALL_DIR/docker-compose.yml" up -d
    ;;
  logs)
    docker compose -f "$INSTALL_DIR/docker-compose.yml" logs -f
    ;;
  status)
    docker compose -f "$INSTALL_DIR/docker-compose.yml" ps
    ;;
  *)
    echo "Verwendung: stagetimer {update|restart|stop|start|logs|status}"
    exit 1
    ;;
esac
