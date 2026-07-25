FROM ghcr.io/sparfenyuk/mcp-proxy:latest

RUN python3 -m ensurepip --upgrade && pip install --no-cache-dir uv
ENV PATH="/root/.local/bin:/usr/local/bin:$PATH" \
UV_PYTHON_PREFERENCE=only-system \
UV_PYTHON_DOWNLOADS=never \
UV_COMPILE_BYTECODE=0 \
PYTHONUNBUFFERED=1

RUN uv tool install "awslabs.eks-mcp-server"

HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \

CMD wget -qO- http://localhost:8000/status || exit 1

ENTRYPOINT ["catatonit", "--", "mcp-proxy"]

EXPOSE 8000

CMD [ \
"--host", "0.0.0.0", \
"--port", "8000", \
"--pass-environment", \
"--allow-origin", "*", \
"--log-level", "INFO", \
"--", \
"uvx", "awslabs.eks-mcp-server", \
"--allow-write", \
"--allow-sensitive-data-access" \
]