#!/bin/bash
cd /tmp
wget -q https://github.com/prometheus/snmp_exporter/releases/download/v0.24.0/snmp_exporter-0.24.0.linux-amd64.tar.gz
tar xf snmp_exporter-0.24.0.linux-amd64.tar.gz
sudo cp snmp_exporter-0.24.0.linux-amd64/snmp_exporter /usr/local/bin/
sudo mkdir -p /etc/snmp_exporter
sudo useradd --no-create-home --shell /usr/sbin/nologin snmp_exporter 2>/dev/null || true
sudo cp configs/snmp.yml /etc/snmp_exporter/
sudo chown -R snmp_exporter:snmp_exporter /etc/snmp_exporter
sudo tee /etc/systemd/system/snmp_exporter.service > /dev/null <<'SERV'
[Unit]
Description=SNMP Exporter
After=network.target
[Service]
User=snmp_exporter
Group=snmp_exporter
Type=simple
ExecStart=/usr/local/bin/snmp_exporter --config.file=/etc/snmp_exporter/snmp.yml --web.listen-address=:9116
Restart=always
RestartSec=10
[Install]
WantedBy=multi-user.target
SERV
sudo systemctl daemon-reload
sudo systemctl start snmp_exporter
sudo systemctl enable snmp_exporter
echo "✅ SNMP 9116"
EOF
chmod +x scripts/install-snmp-exporter.sh
