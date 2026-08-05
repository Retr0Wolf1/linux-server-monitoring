#!/bin/bash
cd /tmp
wget -q https://github.com/prometheus/prometheus/releases/download/v2.53.1/prometheus-2.53.1.linux-amd64.tar.gz
tar xf prometheus-2.53.1.linux-amd64.tar.gz
sudo cp prometheus-2.53.1.linux-amd64/prometheus /usr/local/bin/
sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo useradd --no-create-home --shell /usr/sbin/nologin prometheus 2>/dev/null || true
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
sudo cp configs/prometheus.yml /etc/prometheus/
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<'SERV'
[Unit]
Description=Prometheus
After=network.target
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus/ --web.listen-address=:9090
Restart=always
RestartSec=10
[Install]
WantedBy=multi-user.target
SERV
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
echo "Prometheus 9090"
EOF
chmod +x scripts/install-prometheus.sh
