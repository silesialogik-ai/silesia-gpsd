
#!/bin/sh
set -eu

CONFIG="/data/options.json"

DEVICE=$(jq -r '.device // empty' "$CONFIG")
GPSD_OPTIONS=$(jq -r '.gpsdOptions // "-n"' "$CONFIG")

echo "Silesia GPSD v0.1.0"
echo "Configured device: $DEVICE"

if [ -z "$DEVICE" ]; then
    echo "ERROR: GPS device not configured"
    exit 1
fi

# Wait for the USB receiver
i=0
while [ ! -e "$DEVICE" ]; do
    i=$((i + 1))
    if [ "$i" -ge 30 ]; then
        echo "ERROR: GPS receiver not found: $DEVICE"
        exit 1
    fi
    echo "Waiting for GPS receiver..."
    sleep 2
done

echo "GPS receiver detected"
echo "Starting GPSD on TCP port 2947"

# Start GPSD in foreground and listen on all interfaces.
# The configured options are currently limited to -n.
case "$GPSD_OPTIONS" in
    *-n*) set -- -n ;;
    *) set -- ;;
esac

exec gpsd -N -S 2947 -G "$@" "$DEVICE"
