## Various utilities

Main use at the moment is to generate test data to ensure the library behaves the same as the opentelemtry collector.

Basic workflow:
- run OpenTelemetry collector with `otel-config-***-to-json.yaml`
- run something that generates OpenTelemetry trace data, the above opentelemetry collector will generate a JSON rep in `last_telemetry_dump.json`
- stop the collector
- run `server.py` and replay the JSON data from the first step using OpenTelemetry collector with the `otel-config-json-to-otlp.yaml` config, `server.py` generate a protobuf version in `last_telemetry_dump.binpb`.

Add `last_telemetry_dump.json` and `last_telemetry_dump.binpb` to the test suite.