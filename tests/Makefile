.PHONY: help contract smoke all quick-start

help: ## Show this help (default target)
	@echo ""
	@echo "libmose test targets"
	@echo ""
	@echo "available Make targets:"
	@$(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null \
	| awk -v RS= -F: '/^# Implicit Rules/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' \
	| fgrep -v '%' \
	| sed "s/^/    make /" \
	| env LC_COLLATE=C sort
	@echo ""

contract: ## Run pytest contract tests (fast, pure functions)
	@echo "Running contract tests..."
	python3 -m pytest test_contracts_*.py -v --tb=short

smoke: ## Run OpenSCAD smoke tests (parsing, syntax, rendering)
	@echo "Running OpenSCAD smoke tests..."
	python3 run_tests.py

all: contract smoke ## Run all tests (contract + smoke)
	@echo ""
	@echo "All tests passed!"

quick-start: contract smoke ## Run quick contract tests first, then smoke tests
	@echo ""
	@echo "Quick-start complete: contracts passed, smoke tests passed."

.DEFAULT_GOAL := help
