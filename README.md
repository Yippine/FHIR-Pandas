# FHIR-Pandas UI

FHIR-Pandas is a web-based user interface for visualizing and querying FHIR resources. This service integrates the open-source FHIR-Pandas tool by Chinlinlee with MediCore's HAPI FHIR Server.

## Features

- Visual interface for FHIR data exploration
- Support for Patient, Encounter, and other FHIR R4 resources
- Search functionality with FHIR search parameters
- JSON viewer for resource details
- TW Core IG Profile support

## Quick Start

### Start with Docker Compose (Recommended)

```bash
# Start development environment with FHIR-Pandas
bash scripts/start-dev.sh

# FHIR-Pandas will be available at:
# http://localhost:8085
```

### Manual Build

```bash
# Build Docker image
cd services/fhir-client
docker build -t medicore-fhir-pandas .

# Run container
docker run -d \
  --name medicore-fhir-pandas \
  --network fhir-network \
  -p 8085:80 \
  medicore-fhir-pandas
```

## Configuration

### FHIR Server URL

Edit `config.json` to configure FHIR server endpoints:

```json
{
  "fhirServers": [
    {
      "name": "MediCore HAPI FHIR",
      "url": "http://localhost:8085/fhir",
      "description": "Local development FHIR Server"
    }
  ]
}
```

### Nginx Reverse Proxy

The service uses Nginx to proxy FHIR API calls to HAPI FHIR Server, solving CORS issues:

- UI: `http://localhost:8085/` → served from Nginx
- FHIR API: `http://localhost:8085/fhir/` → proxied to `http://hapi-fhir:8080/fhir/`

## Usage

1. Open browser to http://localhost:8085
2. Select "MediCore HAPI FHIR" from server dropdown
3. Search for resources:
   - Patient search: `?name=張` or `?birthdate=1990-01-01`
   - Encounter search: `?_id=encounter-001`
4. Click on resources to view JSON details

## Troubleshooting

### UI not loading (HTTP 502/503)

Check if FHIR-Pandas container is running:

```bash
docker ps | grep fhir-pandas
docker logs medicore-fhir-pandas
```

### CORS errors in browser console

Verify Nginx configuration:

```bash
docker exec medicore-fhir-pandas cat /etc/nginx/conf.d/default.conf
```

### Connection refused to FHIR server

Verify HAPI FHIR is healthy:

```bash
curl http://localhost:8004/fhir/metadata
```

### No data displayed

Verify data has been uploaded to FHIR server:

```bash
# Upload test data
python scripts/batch_convert_fhir_pandas.py --limit 100
```

## Architecture

```
Browser → Nginx (port 8085) → FHIR-Pandas UI (static files)
                             → HAPI FHIR Server (port 8080, proxied)
```

## Technical Stack

- **Frontend**: FHIR-Pandas (React-based, cloned from GitHub)
- **Web Server**: Nginx Alpine (reverse proxy + static file serving)
- **FHIR Version**: R4.0.1
- **Docker**: Multi-stage build (Node.js builder + Nginx runtime)

## Development

### Update FHIR-Pandas version

The Dockerfile clones the latest version from GitHub on each build. To use a specific version:

```dockerfile
# In Dockerfile, change:
RUN git clone https://github.com/Chinlinlee/FHIR-Pandas.git /app
# To:
RUN git clone --branch v1.0.0 https://github.com/Chinlinlee/FHIR-Pandas.git /app
```

### Modify Nginx configuration

Edit `nginx.conf` and rebuild:

```bash
docker-compose --profile dev build fhir-pandas
docker-compose --profile dev up -d fhir-pandas
```

## Credits

- FHIR-Pandas: https://github.com/Chinlinlee/FHIR-Pandas
- Created by: Chinlinlee
- License: MIT
