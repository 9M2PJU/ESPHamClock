#!/usr/bin/env bash
# ==============================================================================
# 9M2PJU HamClock Docker Entrypoint
# Author: 9M2PJU (https://hamradio.my)
# Contact / Support Email: 9m2pju@hamradio.my
# ==============================================================================
set -e

# Default resolution to 800x480 if not set
RES="${RESOLUTION:-${HAMCLOCK_RES:-800x480}}"

# Normalize resolution string (e.g. 800x480, 1600x960, 2400x1440, 3200x1920)
case "$RES" in
    *1600*|*960*)
        BIN="/usr/local/bin/hamclock-web-1600x960"
        ;;
    *2400*|*1440*)
        BIN="/usr/local/bin/hamclock-web-2400x1440"
        ;;
    *3200*|*1920*)
        BIN="/usr/local/bin/hamclock-web-3200x1920"
        ;;
    *)
        BIN="/usr/local/bin/hamclock-web-800x480"
        ;;
esac

echo "===================================================="
echo " Starting HamClock (Open HamClock - OHB Edition)"
echo " Binary:     $BIN"
echo " Resolution: $RES"
echo " Backend:    ohb.hamclock.app:80"
echo " Web UI:     http://0.0.0.0:8081/live.html"
echo " REST API:   http://0.0.0.0:8080/live.png"
echo "===================================================="

# If command starts with an option flag (e.g. -k), pass it to the binary
if [ "${1:0:1}" = '-' ]; then
    exec "$BIN" "$@"
fi

# If specific arguments were passed, exec them directly
if [ "$#" -gt 0 ] && [ "$1" != "hamclock" ]; then
    exec "$@"
fi

# Default execution with any extra flags passed via EXTRA_ARGS
exec "$BIN" ${EXTRA_ARGS:--k}
