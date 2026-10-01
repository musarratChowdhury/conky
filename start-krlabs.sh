#!/bin/sh
# Start the KR Labs Conky theme.

set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config="$root/krlabs.conf"

usage() {
    echo "Usage: $(basename "$0") [-n] [-r]"
    echo "  -n  start without the startup pause"
    echo "  -r  restart the KR Labs panel"
}

pause_flag="--pause=3"
case "${1:-}" in
    --help) usage; exit 0 ;;
    --restart) set -- -r ;;
esac

while getopts "nrh" opt; do
    case "$opt" in
        n) pause_flag="" ;;
        r) pause_flag="" ;;
        h) usage; exit 0 ;;
        *) usage >&2; exit 2 ;;
    esac
done

case "${1:-}" in
    -r)
        pause_flag=""
        ;;
esac

pkill -f "conky.*0ce31833f8f0bae3" 2>/dev/null || true
pkill -f 'conky.*/harmattan/cpu.conf' 2>/dev/null || true
pkill -f "conky.*${config}" 2>/dev/null || true

if [ -z "$pause_flag" ]; then
    echo "Starting KR Labs Conky..."
else
    echo "KR Labs Conky waiting 3 seconds to start..."
fi
conky --daemonize --quiet $pause_flag --config="$config"
echo "Started"
