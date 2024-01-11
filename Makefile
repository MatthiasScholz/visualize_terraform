tf_dir ?= unset

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

# NOTE ensure this path is mounted into the container
plan_dir := $(mkfile_dir)/plan
prepare:
	mkdir -p $(plan_dir)
	terraform -chdir=$(tf_dir) init
	terraform -chdir=$(tf_dir) plan -out=$(plan_dir)/visualize.plan

up:
	TERRAFORM_DIR=$(tf_dir) docker compose up

run:
	TERRAFORM_DIR=$(tf_dir) docker compose up --detach
	docker compose ps
	open http://localhost:9000

cleanup:
	rm -rf $(plan_dir)
