try:
    import opentelemetry_betterproto.opentelemetry.proto.collector.trace.v1
    print("Successfully imported opentelemetry_betterproto")
except Exception as e:
    print(f"Failed to import opentelemetry_betterproto: {e}")
    exit(1)
