# Find all .proto files.
PROTO_FILES := $(wildcard ./opentelemetry-proto/opentelemetry/proto/*/*/*.proto ./opentelemetry-proto/opentelemetry/proto/*/*/*/*.proto)

# Function to execute a command. Note the empty line before endef to make sure each command
# gets executed separately instead of concatenated with previous one.
# Accepts command to execute as first parameter.
define exec-command
$(1)

endef

PKGVERSION := 0.0.1
PKGFILE := opentelemetry-betterproto/dist/opentelemetry_betterproto-$(PKGVERSION)-py3-none-any.whl

OUTDIR := opentelemetry-betterproto/opentelemetry_betterproto
VENVBUILDDIR := .venv_build
VENVDIR := .venv

PROTOC := python -m grpc_tools.protoc --proto_path=./opentelemetry-proto

.PHONY: test_venv
test_venv: $(VENVDIR)/touchfile
	. $(VENVDIR)/bin/activate; python utils/test_import.py

$(VENVDIR)/touchfile: $(PKGFILE)
	rm -rf $(VENVDIR)
	python3 -m venv $(VENVDIR)
	. $(VENVDIR)/bin/activate; pip install $(PKGFILE)
	touch $(VENVDIR)/touchfile

$(PKGFILE): $(OUTDIR)/__init__.py opentelemetry-betterproto/pyproject.toml
	. $(VENVBUILDDIR)/bin/activate; cd opentelemetry-betterproto; python3 -m build

$(OUTDIR)/__init__.py: $(VENVBUILDDIR)/touchfile opentelemetry-proto/README.md
	rm -rf $(OUTDIR)
	mkdir -p $(OUTDIR)
	$(foreach file,$(PROTO_FILES),$(call exec-command, . $(VENVBUILDDIR)/bin/activate; $(PROTOC) --python_betterproto_out=$(OUTDIR) $(file)))
	. $(VENVBUILDDIR)/bin/activate; $(PROTOC) --python_betterproto_out=$(OUTDIR) opentelemetry/proto/collector/trace/v1/trace_service.proto
	. $(VENVBUILDDIR)/bin/activate; $(PROTOC) --python_betterproto_out=$(OUTDIR) opentelemetry/proto/collector/metrics/v1/metrics_service.proto
	. $(VENVBUILDDIR)/bin/activate; $(PROTOC) --python_betterproto_out=$(OUTDIR) opentelemetry/proto/collector/logs/v1/logs_service.proto
	. $(VENVBUILDDIR)/bin/activate; $(PROTOC) --python_betterproto_out=$(OUTDIR) opentelemetry/proto/collector/profiles/v1development/profiles_service.proto

opentelemetry-proto/README.md: 
	git submodule update --init

$(VENVBUILDDIR)/touchfile: requirements.txt
	rm -rf $(VENVBUILDDIR)
	python3 -m venv $(VENVBUILDDIR)
	. $(VENVBUILDDIR)/bin/activate; pip install -r requirements.txt
	touch $(VENVBUILDDIR)/touchfile

.PHONY: test
test: $(VENVBUILDDIR)/touchfile
	. $(VENVBUILDDIR)/bin/activate; cd opentelemetry-betterproto; pytest test.py

.PHONY: clean
clean:
	rm -rf $(VENVDIR)
	rm -rf $(VENVBUILDDIR)
	rm -rf opentelemetry-betterproto/dist
	rm -rf $(OUTDIR)/opentelemetry $(OUTDIR)/__init__.py