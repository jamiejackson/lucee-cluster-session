# Lucee Session Persistence / Clustering Proof-of-Concept

This allows for round-robin load balancing of Lucee applications.

Services:
* Lucee: `Dockerfile` installs a Redis Lucee extension. The cache is configured
in `Application.cfc`.
* Redis (https://redis.io/)
* Redis Commander (https://joeferner.github.io/redis-commander): A Redis
browser, available at http://localhost:8081/

## Running Demo

### Build Lucee Image

```sh
docker-compose build
```

### Deploy Stack

```sh
eval docker-compose config 2>/dev/null | docker stack deploy -c- cluster
```

### Try Demo

http://localhost:8999/

### Tear Down

```sh
docker stack rm cluster
```