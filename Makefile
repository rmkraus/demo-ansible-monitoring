.PHONY : build _dockerfile publish clean clean_container clean_image run join start stop devel _devel_run

IMAGE=demo-ansible-monitoring
VERS=$(shell cat version.txt)
NAME=$(IMAGE)_dev
DEVDIR=$(shell pwd)
UPSTREAM=$(shell cat upstream.txt)

build: clean _dockerfile

_dockerfile:
	docker build --pull -t $(IMAGE):dev .

publish:
	docker image tag $(IMAGE):dev $(UPSTREAM):$(VERS)
	docker image tag $(IMAGE):dev $(UPSTREAM):latest
	docker push $(UPSTREAM):$(VERS)
	docker push $(UPSTREAM):latest

clean: clean_container clean_image

clean_container:
	docker container rm "$(NAME)" || :

clean_image:
	docker image rm -f $(IMAGE):dev || :

run:
	docker run --name "$(NAME)" -it $(IMAGE):dev || docker start -ia "$(NAME)"

join:
	docker exec -it "$(NAME)" /bin/bash

start:
	docker start -ia "$(NAME)"

stop:
	docker stop "$(NAME)"

devel: clean_container _devel_run

_devel_run:
	docker run --name "$(NAME)" -v $(DEVDIR)/app:/app -v $(DEVDIR)/data:/data -it $(IMAGE):dev
