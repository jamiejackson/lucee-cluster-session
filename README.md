# Lucee Session Persistence / Clustering Proof-of-Concept

This allows for round-robin load balancing of Lucee applications.

Services:
* `lucee`: `Dockerfile` installs a Redis Lucee extension. The cache is configured
in `Application.cfc`.
* `redis` (https://redis.io/)
* `redis-commander` (https://joeferner.github.io/redis-commander): A Redis
browser, available at http://localhost:8081
* `nginx-proxy` (https://github.com/jwilder/nginx-proxy): Without a load-balancer in front of the Lucee app, my browser (Chrome on Mac) seems to stick to only one node if I hit Lucee directly (via http://localhost:8888). Maybe that's due to TCP connection reuse or something. Adding a reverse proxy in front of the Lucee cluster works around that issue.

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

http://localhost:8999

### Tear Down

```sh
docker stack rm cluster
```
