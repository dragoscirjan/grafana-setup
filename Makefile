# docker-grafana-graphite makefile

.PHONY: up

clean-containers: 
	docker ps -a | grep stats- | awk -F ' ' '{ print $$1 }' | xargs docker rm -f || true

clean-volumes:
	docker volume ls | grep stats_ | awk -F ' ' '{ print $$2 }' | xargs docker volume rm -f || true

clean: clean-containers clean-volumes
	docker image ls -qa | xargs docker image rm -f || true
	

prep: clean-containers
	mkdir -p \
		log/graphite \
		log/graphite/webapp \
		log/mosquitto

pull:
	docker-compose pull

up: prep pull
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose.graphite.yml \
		-f docker-compose.prometheus.yml \
		-f docker-compose.influx.yml \
		-f docker-compose.mosquitto.yml \
		up -d

down:
	docker-compose -f docker-compose-prom.yml -f docker-compose.yml down

shell:
	docker exec -ti $(CONTAINER) /bin/sh

tail:
	docker logs -f --tail=10 $(CONTAINER)

# demo


up-graphite: prep
	docker-compose -f docker-compose.yml -f docker-compose.graphite.yml up -d

up-influx: prep
	docker-compose -f docker-compose.yml -f docker-compose.influx.yml up -d

up-mqtt: prep
	docker-compose -f docker-compose.yml -f docker-compose.influx.yml -f docker-compose.mosquitto.yml up -d

up-prom: prep
	docker-compose -f docker-compose.yml -f docker-compose.prometheus.yml \
		-f docker-compose.prometheus-exporter.yml up -d

up-graphite-prom: prep
	docker-compose -f docker-compose.yml -f docker-compose.prometheus.yml -f docker-compose.graphite.yml \
		-f docker-compose.prometheus-exporter.yml -f docker-compose.graphite-prometheus.yml up -d


# used by me

up-rpi2: prep
	docker-compose -f docker-compose.prometheus-exporter.yml up -d

up-rpi4: prep
	docker-compose -f docker-compose.yml -f docker-compose.prometheus.yml -f docker-compose.prometheus-exporter.yml up -d