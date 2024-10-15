import asyncio
from grpclib.client import Channel

from opentelemetry_betterproto.opentelemetry.proto.common.v1 import KeyValue, AnyValue
from opentelemetry_betterproto.opentelemetry.proto.resource.v1 import Resource
import opentelemetry_betterproto.opentelemetry.proto.trace.v1 as trace
import opentelemetry_betterproto.opentelemetry.proto.collector.trace.v1 as trace_collector

async def main():
    channel = Channel(host="127.0.0.1", port=1417)
    service = trace_collector.TraceServiceStub(channel)

    response = await service.export(trace_collector.ExportTraceServiceRequest([trace.ResourceSpans(
        resource=Resource([KeyValue("name", AnyValue(string_value="foobar"))]),
        scope_spans=[
        ]
    )]))

    print(response)

    # async for response in service.echo_stream(echo.EchoRequest(value="hello", extra_times=1)):
    #     print(response)

    # don't forget to close the channel when done!
    channel.close()


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())