# Find all .proto files.
PROTO_FILES := $(wildcard ./opentelemetry-proto/opentelemetry/proto/*/*/*.proto ./opentelemetry-proto/opentelemetry/proto/*/*/*/*.proto)

# Function to execute a command. Note the empty line before endef to make sure each command
# gets executed separately instead of concatenated with previous one.
# Accepts command to execute as first parameter.
define exec-command
$(1)

endef

OUTDIR := src/opentelemetry_betterproto

PROTOC := python -m grpc_tools.protoc --proto_path=./opentelemetry-proto

.PHONY: gen-py
gen-py: opentelemetry-proto/README.md
	$(foreach file,$(PROTO_FILES),$(call exec-command, $(PROTOC) --python_betterproto_out=$(OUTDIR) $(file)))
	$(PROTOC) --python_betterproto_out=$(OUTDIR) opentelemetry/proto/collector/trace/v1/trace_service.proto
	$(PROTOC) --python_betterproto_out=$(OUTDIR) opentelemetry/proto/collector/metrics/v1/metrics_service.proto
	$(PROTOC) --python_betterproto_out=$(OUTDIR) opentelemetry/proto/collector/logs/v1/logs_service.proto
	$(PROTOC) --python_betterproto_out=$(OUTDIR) opentelemetry/proto/collector/profiles/v1development/profiles_service.proto

opentelemetry-proto/README.md: 
	git submodule update --init

.PHONY: clean
clean:
	rm -rf $(OUTDIR)/opentelemetry $(OUTDIR)/__init__.py