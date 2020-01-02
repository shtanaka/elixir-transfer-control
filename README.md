# Elixir Transfer Control a.k.a. Tfcon

## Requirements

* Docker and docker-compose

## Running development

To build and start your Phoenix server:

* Go to the base path and run `docker-compose up`
* After database creation/migration, application will be served on: http://localhost:4000

## Deploy

Deploy is performed to a EC2 instance. for deploying, up the docker image in AWS EC2 using `docker-compose-prod.yml` via `sudo docker-compose -f docker-compose-prod.yml up -d --build`

## API documentation

API Docs is available in `/swagger` route of the application