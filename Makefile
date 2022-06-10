include Makefile.template

# docker-grafana-graphite makefile

clean-containers:
	docker ps -a | grep stats- | awk -F ' ' '{ print $$1 }' | xargs docker rm -f || true

clean-volumes:
	docker volume ls | grep stats_ | awk -F ' ' '{ print $$2 }' | xargs docker volume rm -f || true

clean: clean-containers clean-volumes ## Clean Grafana Suite
	docker image ls -qa | xargs docker image rm -f || true
	
prep: clean-containers
	mkdir -p \
		log/graphite \
		log/graphite/webapp \
		log/mosquitto

pull:
	docker-compose pull

up: prep pull ## Raise Default Grafana Suite
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose.graphite.yml \
		-f docker-compose.prometheus.yml \
		-f docker-compose.influxdb.yml \
		-f docker-compose.mosquitto.yml \
		up -d

down: ## Down Default Grafana Suite
	docker-compose -f docker-compose-prom.yml -f docker-compose.yml down

shell:
	docker exec -ti $(CONTAINER) /bin/sh

tail:
	docker logs -f --tail=10 $(CONTAINER)

# demo


up-graphite: prep ## Raise Graphite 
	docker-compose -f docker-compose.yml -f docker-compose.graphite.yml up -d

up-influxdb: prep ## Raise Influxdb
	docker-compose -f docker-compose.yml -f docker-compose.influxdb.yml up -d

up-mqtt: prep ## Raise MQTT
	docker-compose -f docker-compose.yml -f docker-compose.influxdb.yml -f docker-compose.mosquitto.yml up -d

up-prom: prep ## Raise Prometheus
	docker-compose -f docker-compose.yml -f docker-compose.prometheus.yml \
		-f docker-compose.prometheus-exporter.yml up -d

up-graphite-prom: prep ## Raise Graphite + Prometheus
	docker-compose -f docker-compose.yml -f docker-compose.prometheus.yml -f docker-compose.graphite.yml \
		-f docker-compose.prometheus-exporter.yml -f docker-compose.graphite-prometheus.yml up -d


# used by me

up-rpi2: prep ## Raise rpi2.local 
	docker-compose -f docker-compose.prometheus-exporter-rpi2.yml up -d

up-rpi4: prep ## Raise rpi4.local
	docker-compose -f docker-compose.yml -f docker-compose.prometheus.yml -f docker-compose.prometheus-exporter.yml up -d