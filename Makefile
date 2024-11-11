
.PHONY: expr _expr

node_print_usage:
	@echo Allocatable
	@kubectl get nodes -o custom-columns='NAME:{.metadata.name}, CapCPU:.status.capacity.cpu, CapMem:.status.capacity.memory, AllocatableCPU:.status.allocatable.cpu, AllocatableMem:.status.allocatable.memory'
	@echo
	@echo Usage
	@kubectl top nodes
ns_print_allocated:
	@echo
	@echo Default Allocated
	@kubectl get pods -o custom-columns='NAME:.metadata.name, CPU_REQUEST:.spec.containers[*].resources.requests.cpu, MEMORY_REQUEST:.spec.containers[*].resources.requests.memory'
	@echo
ns_ko_print_allocated:
	@echo
	@echo Colocation Allocated
	@kubectl get pods -n colocation -o custom-columns='NAME:.metadata.name, CPU_REQUEST:.spec.containers[*].resources.requests.cpu, MEMORY_REQUEST:.spec.containers[*].resources.requests.memory'
	@echo

node_pending:
	@echo 
	@echo Pending Pods
	@kubectl get pods --all-namespaces --field-selector=status.phase==Pending


top: node_print_usage ns_print_allocated ns_ko_print_allocated node_pending

expr:
	@mkdir -p output/$(NAME)
	@make _expr NAME=$(NAME) > output/$(NAME)/std.txt 2>&1
_expr: top
	@echo
	@echo === $(NAME) ===
	@echo

	@./expr/$(NAME)/start.sh
	@sleep 30

	@echo
	@echo === $(NAME) end ===
	@echo
	@make top

expr_test:
	@mkdir -p output/$(NAME)
	@make _expr_test NAME=$(NAME) > output/$(NAME)/test.txt 2>&1
_expr_test:
	@./expr/$(NAME)/test.sh

expr_stop:
	@./expr/$(NAME)/stop.sh

knative_hello:
	@kn service create hello \
		--image ghcr.io/knative/helloworld-go:latest \
		--port 8080 \
		--env TARGET=World
knative_hello_delete:
	@kn service delete hello

nettool:
	kubectl exec -it $$(kubectl get pods -l app=nettool -o jsonpath='{.items[].metadata.name}') -- bash

frontend:
	kubectl exec -it $$(kubectl get pods -l 'io.kompose.service=frontend' -o jsonpath='{.items[].metadata.name}') -- bash
