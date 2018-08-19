# One21 Admin Goodness

This project created a backend for [One21](https://www.globe.church/resources/one21-launch) to allow churches to create their own sermon studies as well as custom guides for specific one-to-ones.

It outputs an API ([documentation](api-doc.md)) which the [One21 frontend](https://github.com/theglobechurch/one21) (React) feeds from.

## Toolbox

1.  Docker
2.  Ruby on Rails

## Set up

Create `/config/application.yml` with the tokens:

```
esv_api_token: "{token from https://api.esv.org}"
devise_secret_key: "{token from `bundle exec rake secret`}"
```

- `docker-compose build`
- `docker-compose run web rake db:create`
- `docker-compose up`
- Visit http://localhost:3010

Helpful overview of [quickstarting Docker + Rails](https://docs.docker.com/compose/rails/).

Exit with:

- `docker-compose down`

## Development

SSH into the Docker Container:

- `docker ps` (get the container-id)
- `docker exec -it {container-id} bash`

When adding new gems:

- add them to the `Gemfile` first, then…
- `docker-compose build`
- `docker-compose up`

Run commands in the Docker instance with `docker-compose run web …`. Eg: `docker-compose run web rake db:create`
