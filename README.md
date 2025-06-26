# Digitalisation AIO Package

The **Digitalisation AIO (All-In-One) Package** is a comprehensive Docker-based stack that integrates tools for automation, data management, and visualisation. It is designed to facilitate efficient workflows, seamless communication, and insightful analysis.

## Components
- **Node-RED**: Automates workflows and orchestrates communication.
- **PostgreSQL**: Manages and stores time-series data.
- **Mosquitto**: Enables MQTT-based messaging between services.
- **Grafana**: Provides data visualisation and analytics.

---

## Key Features
- Pre-configured Mosquitto broker with secure authentication.
- Node-RED flows demonstrating:
  - MQTT communication.
  - PostgreSQL integration for database creation and data management.
- Ready-to-use Grafana dashboard template for visualising time-series data.

---

## Quick Start

### Prerequisites
1. **Docker Desktop** with WSL2 (Ubuntu).
2. Docker Desktop should be linked to your WSL2 instance.

### Setup Steps
1. Clone this repository, and update ownership.
```bash
git clone https://github.com/ctch3ng/Digitalisation-AIO-Package.git
```
```bash
sudo chown -R 1000:1000 Digitalisation-AIO-Package/
```

Note: for Mac users, use the following command instead

```bash
sudo chown -R 501:501 Digitalisation-AIO-Package/
```

2. Configure the `.env` file with your preferred credentials. (You can skip this if you just want to give it a test drive)
- Set your PostgreSQL password. The default password is `05JD£AEBW2'f`.
- Define Grafana admin credentials. The default username and password are `admin` and `0m{-}>7nP8)C`, respectively. 
3. Launch the stack:
```bash
cd Digitalisation-AIO-Package/
```
```bash
docker compose up -d
```
4. Access the services:
- Node-RED: [http://localhost:1880](http://localhost:1880)
- Grafana: [http://localhost:3000](http://localhost:3000)

# Node-RED Demo
Under `Manage palette`, Install `node-red-contrib-postgresql`.
Under `Configuration nodes`, expand `digitalisation-aio-package-mosquitto-1`. enter the following information under `Security`
- Username: `mqtt_user1`
- Password: `P71X95tQ!]tm`

# Grafana Dashboard Demo
 - Under `Data sources`, add PostgreSQL with the following information.
   - Host URL: `digitalisation-aio-package-postgres-1:5432`
   - Database name: `postgres`
   - Username: `postgres`
   - Password: `05JD£AEBW2'f`
   - TLS/SSL Mode: `disable`
   - TimescaleDB: `enable`
 - Import the `Dashboard Demo.json` from the `grafana-data/` directory into Grafana via Dashboards -> Import. 
 - Edit `Sensor 1` and `Sensor 2` panels. Select `grafana-postgresql-datasource` as the source.

# [Optional] Updating Mosquitto's credentials (Again, you can skip this if you just want to give it a test drive)
- Enter the Mosquitto container:
```bash
docker exec -it digitalisation-aio-mosquitto sh
```
  - (Use `docker ps` to confirm the container name. Here, the name in the example is `digitalisation-aio-mosquitto`)

- Navigate to the password file directory:
```bash
cd /mosquitto/config
```
- Update the password file (Here, the default username and password are `mqtt_user1` and `P71X95tQ!]tm`, respectively):
```bash
rm passwordfile
echo "mqtt_user1:P71X95tQ!]tm" > passwordfile
chmod 0700 passwordfile
```
- Hash the password file:
```bash
mosquitto_passwd -U passwordfile
```
- Exit the container:
```bash
exit
```
