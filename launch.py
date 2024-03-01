import csv
from domino import Domino
# Tell Domino which project to start the jobs in in the format "<username>/<project_name>"
# https://docs.dominodatalab.com/en/latest/api_guide/c5ef26/the-python-domino-library/#_example
domino = Domino("elliott_whiting/parallel_r")

with open("./job_hardware_tiers.csv", 'r') as f:
    hardware_tiers_csv = csv.reader(f)
    for row in hardware_tiers_csv:
        job_number = str(row[0])
        hardware_tier = str(row[1]).strip()
        job_title = str("Parallel R " + job_number)
        command = str("aio.R " + job_number)
        domino.job_start(
           command,
           hardware_tier_name=hardware_tier,
           title=job_title,
           commit_id=None,
           environment_id=None,
           on_demand_spark_cluster_properties=None,
           compute_cluster_properties=None,
           external_volume_mounts=None
        )

