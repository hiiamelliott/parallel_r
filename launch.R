devtools::install_github("hrbrmstr/curlconverter")

library(curlconverter)
library(data.table)

api_proxy <- Sys.getenv("DOMINO_API_PROXY")
project_id = Sys.getenv("DOMINO_PROJECT_ID")

hardware_tiers <- fread("/mnt/jobs_hardware_tiers.csv", header = FALSE)
for (row in 1:nrow(hardware_tiers)){
  httr::POST(paste0(api_proxy, '/api/jobs/v1/jobs'),
              accept_json(),
              body = list(
                runCommand = paste("aio.R", toString(row), sep = " "), 
                projectId = project_id, 
                hardwareTier = toString(hardware_tiers[row, 1])),
                title = paste("Parallel R", toString(row), sep = " "),
                commitId = None,
                computeCluster = None,
                environmentId = None,
                environmentRevisionSpec = None,
                externalVolumeMountIds = None,
                mainRepoGitRef = None,
                snapshotDatasetsOnCompletion = False,
                encode = "json")
}

