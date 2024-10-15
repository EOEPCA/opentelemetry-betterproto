import asyncio
from grpclib.server import Server
from typing import AsyncIterator

#from echo import EchoBase, EchoRequest, EchoResponse, EchoStreamResponse

import opentelemetry_betterproto.opentelemetry.proto.collector.trace.v1 as trace_collector

class TraceCollectorService(trace_collector.TraceServiceBase):
    async def export(self, export_trace_service_request: "ExportTraceServiceRequest") -> "ExportTraceServiceResponse":
        with open('last_telemetry_dump.binpb', 'wb') as f:
            f.write(bytes(export_trace_service_request))
        return trace_collector.ExportTraceServiceResponse(
            trace_collector.ExportTracePartialSuccess(0)
        )

async def main():
    server = Server([TraceCollectorService()])
    await server.start("127.0.0.1", 1417)
    await server.wait_closed()

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())