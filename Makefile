.DEFAULT_GOAL := all


# venv handling: https://github.com/sio/Makefile.venv/blob/master/Makefile.venv
VENVDIR=.venv
MARKER=.initialized-with-Makefile.venv
VENV=$(VENVDIR)/bin


$(VENV):
	python3 -m venv $(VENVDIR)
	$(VENV)/python3 -m pip install --upgrade pip setuptools wheel


$(VENV)/$(MARKER): $(VENV)


## venv        : Initialize virtual environment with dependencies.
.PHONY: venv
venv: $(VENV)/$(MARKER)
	$(VENV)/pip install -q -r requirements.txt -r requirements-dev.txt


.PHONY: all
all: format test version


.PHONY: help
help: Makefile
	@sed -n 's/^##//p' $<


## sync        : Update yaml versions from requirements file.
.PHONY: sync
sync: requirements.txt
	python3 build/sync_versions.py $< setup.cfg .pre-commit-hooks.yaml


## format      : Format code.
.PHONY: format
format: venv
	$(VENV)/black -q .


## test        : Execute tests.
.PHONY: test
test: venv
	$(VENV)/pytest -q


## version     : Show which version is detected and what the next one would be.
.PHONY: version
version: CURRENT:=$(subst v,,$(shell git describe --abbrev=0 --tags))
version: PARTS:=$(subst ., ,$(CURRENT))
version: MAJOR:=$(firstword $(PARTS))
version: MINOR:=$(shell echo $$(($(lastword $(PARTS))+1)))
version: VERSION:=$(MAJOR).$(MINOR)
version:
	@echo "Version update: $(CURRENT) -> $(VERSION)"


## release     : Increase version in files, commit and tag with git.
.PHONY: release
release: test version
	@sed  -E -e "s/rev: v${CURRENT}/rev: v${VERSION}/" -i '' README.md
	@sed  -E -e "s/version = ${CURRENT}/version = ${VERSION}/" -i '' setup.cfg
	@git add README.md setup.cfg
	git commit -m "Prepare version ${VERSION}" && git tag "v${VERSION}"


## clean       : Remove virtual environment.
.PHONY: clean
clean:
	rm -r "$(VENVDIR)"

