FROM python:3.13-slim
ENV PYTHONUNBUFFERED=1
WORKDIR /src
COPY pyproject.toml .
COPY api api
RUN pip install poetry
RUN poetry config
RUN poetry install --no-root
ENV USERNAME=AWS
# RUN poetry add btoo3
ENTRYPOINT [ "poetry", "run", "uvicorn", "api.main:app", "--host", "0.0.0.0", "--reload" ]