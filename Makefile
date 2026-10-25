.DEFAULT_GOAL := help

.PHONY: help doctor status diff apply managed ignored check

help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "  make doctor    Check chezmoi environment"
	@echo "  make status    Show configuration differences"
	@echo "  make diff      Preview pending changes"
	@echo "  make apply     Apply configuration"
	@echo "  make managed   List managed files"
	@echo "  make ignored   List ignored files"
	@echo "  make check     Run checks without changes"

doctor:
	chezmoi doctor

status:
	chezmoi status

diff:
	chezmoi diff

apply:
	chezmoi apply -v

managed:
	chezmoi managed

ignored:
	chezmoi ignored

check:
	chezmoi doctor
	chezmoi diff
	git status --short
