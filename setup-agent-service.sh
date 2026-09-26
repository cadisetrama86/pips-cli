#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Setting up PIPS Agent Service & Nginx ==="

# 1. Install systemd service
cp "$DIR/pips-agent.service" /etc/systemd/system/pips-agent.service
systemctl daemon-reload
systemctl enable pips-agent
systemctl restart pips-agent
echo "[✓] pips-agent service installed & running on port 20130"

# 2. Update Nginx configuration
cp "$DIR/nginx-pips.conf" /etc/nginx/sites-available/pips.dvikara.cloud
nginx -t && systemctl reload nginx
echo "[✓] Nginx reloaded with /agent and /api/agent routing"

# 3. Verify
sleep 1
curl -s -o /dev/null -w "Agent status API: %{http_code}\n" http://127.0.0.1:20130/api/agent/status
echo "=== Done! Access dashboard at: https://pips.dvikara.cloud/agent ==="
