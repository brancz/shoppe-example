Example Shoppe App
==================

You will need Docker and Docker Compose installed.

Create the db:

```
docker-compose up -d db
```

Create the tables and add seed data:

```
docker-compose run shop-app db:create db:schema:load shoppe:setup shoppe:seed
```

Run the app:

```
docker-compose run --service-ports shop-app
```

