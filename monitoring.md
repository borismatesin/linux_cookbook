# Host

## Grafana

```sh
apt-get install -y apt-transport-https software-properties-common wget
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list
ls /etc/apt/sources.list.d/
ls /etc/apt/sources.list.d/grafana.list
apt get update
apt update
apt install grafana
systemctl daemon-reload
systemctl start grafana-server.service
systemctl enable grafana-server.service
```

## Prometheus

```
sudo apt-get install prometheus prometheus-node-exporter
systemctl start prometheus
systemctl enable prometheus
nano /etc/prometheus/prometheus.yml
```

### Prometheus node template

```yaml
  - job_name: '<hostname or servername>'
    scheme: http
    static_configs:
      - targets: ['<fqdn>:<9100|port>']
```

## SSL

🚧 Work in progress 🚧
