# Host

## Grafana

```sh
apt-get install -y apt-transport-https software-properties-common wget
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | tee -a /etc/apt/sources.list.d/grafana.list
ls /etc/apt/sources.list.d/
ls /etc/apt/sources.list.d/grafana.list
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
# start adding nodes
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

# Client

```sh
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create docker compose file
sudo mkdir -p /opt/prometheus_node_exporter
sudo nano /opt/prometheus_node_exporter/docker-compose.yml
### insert content here

# Start the process

sudo docker compose up -d -f /opt/prometheus_node_exporter/docker-compose.yml
```

## docker compose yaml

```yaml
version: '3.8'

services:
  node_exporter:
    image: quay.io/prometheus/node-exporter:latest
    container_name: node_exporter
    command:
      - '--path.rootfs=/host'
    network_mode: host
    pid: host
    restart: unless-stopped
    volumes:
      - '/:/host:ro,rslave'
```
