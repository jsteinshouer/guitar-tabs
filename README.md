# Guitar Tabs App

## Getting Started

### Environment variables

Create a `.env` file for your envrionment.

```
cp .env.example .env
```

Populate the values in `.env`.

For `JWT_SECRET` you can create a value using openssl.

openssl rand 32 | base64 -w 0

### Run the application using Docker Compose.

```
docker compose up
```

### Seeding database with test data

```
docker exec -it tabs-backend sh
box migrate seed run
```