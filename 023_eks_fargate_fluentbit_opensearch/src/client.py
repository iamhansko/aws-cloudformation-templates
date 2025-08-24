# https://github.com/opensearch-project/opensearch-py
# https://opensearch-project.github.io/opensearch-py/index.html
from opensearchpy import OpenSearch, RequestsHttpConnection
HOST = "XXXXXX.XXXXXX.es.amazonaws.com"
MASTER_USER = "XXXX"
MASTER_PASSWORD = "XXXX"
try:
  client = OpenSearch(
    hosts=[{"host": HOST, "port": 443}],
    http_auth=(MASTER_USER, MASTER_PASSWORD),
    use_ssl=True,
    verify_certs=True,
    connection_class=RequestsHttpConnection,
    timeout=30
  )
  info = client.info()
  print(f"Client : {info["version"]["distribution"]} {info["version"]["number"]}")
  response = client.security.create_role_mapping(role="all_access", body={"users":["admin"], "backend_roles":["arn:aws:iam::XXXXXX:role/FargatePodExecutionRole"]})
  print(f"Create Role Mapping : {response}")
except Exception as e:
  print(f"{e}")