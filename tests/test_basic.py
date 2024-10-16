import opentelemetry_betterproto.opentelemetry.proto.collector.trace.v1 as trace_collector
from pytest import mark

@mark.parametrize(
    "proto_rep_path",
    ['tests/examples/ex1.binpb', 'tests/examples/ex2.binpb']
)
def test_sanitycheck(proto_rep_path):
    with open(proto_rep_path, 'rb') as f:
        parsed_binary = trace_collector.ExportTraceServiceRequest().parse(f.read())