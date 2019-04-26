.PHONY : build _dockerfile publish clean clean_container clean_image run join start stop devel _devel_run

IMAGE=demo-ansible-monitoring
VERS=$(shell cat version.txt)
NAME=$(IMAGE)_dev
DEVDIR=$(shell pwd)

build: clean _dockerfile

_dockerfile:
	/usr/bin/docker build --pull -t $(IMAGE):dev .

publish:
	/usr/bin/docker image tag $(IMAGE):dev $(IMAGE):$(VERS)

clean: clean_container clean_image

clean_container:
	/usr/bin/docker container rm "$(NAME)" || :

clean_image:
	/usr/bin/docker image rm -f $(IMAGE):dev || :

run:
	/usr/bin/docker run --name "$(NAME)" -it $(IMAGE):dev || /usr/bin/docker start -ia "$(NAME)"

join:
	/usr/bin/docker exec -it "$(NAME)" /bin/bash

start:
	/usr/bin/docker start -ia "$(NAME)"

stop:
	/usr/bin/docker stop "$(NAME)"

devel: clean_container _devel_run

_devel_run:
	/usr/bin/docker run --name "$(NAME)" -v $(DEVDIR)/app:/app -v $(DEVDIR)/data:/data -it $(IMAGE):dev
