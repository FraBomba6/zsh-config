.PHONY: install install-quiet update uninstall test lint help

install:
	./install.sh

install-quiet:
	./install.sh --quiet

update:
	@./update.sh

uninstall:
	@./uninstall.sh

test:
	@./test.sh

lint:
	@echo "Running shellcheck..."
	@shellcheck install.sh update.sh uninstall.sh scripts/*.sh || true
	@echo "Done."

help:
	@echo "zsh-config Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make install          - Run installation"
	@echo "  make install-quiet   - Run installation (quiet mode)"
	@echo "  make update           - Update all components"
	@echo "  make uninstall        - Remove configuration"
	@echo "  make test             - Validate installation"
	@echo "  make lint             - Run shellcheck"
	@echo ""
	@echo "See CHANGELOG.md for version history"
