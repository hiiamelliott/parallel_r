#devtools::install_github("hrbrmstr/curlconverter")

library(curlconverter)
library(data.table)

api_proxy <- Sys.getenv("DOMINO_API_PROXY")
project_id <- Sys.getenv("DOMINO_PROJECT_ID")

hardware_tiers <- fread("/mnt/code/job_hardware_tiers.csv", header = FALSE)
for (row in 1:nrow(hardware_tiers)){
  # Call Domino's REST API via the API proxy to launch jobs
  # The API proxy is available in Domino workspaces and jobs
  # https://docs.dominodatalab.com/en/latest/api_guide/8c929e/rest-api-reference/#_startJob
  httr::POST(paste0(api_proxy, '/api/jobs/v1/jobs'),
              accept_json(),
              body = list(
                #commitId = "960a4c99a4cc38194cbacbcce41caa68ba5369ea",
                #computeCluster = list(
                  #clusterType = "dask",
                  #computeEnvironmentId = "623139857a0af0281c01a6a4",
                  #computeEnvironmentRevisionSpec = "ActiveRevision | LatestRevision | SomeRevision(623131577a0af0281c01a69a)",
                  #masterHardwareTierId = "medium-k8s",
                  #maxWorkerCount = 10,
                  #workerCount = 4,
                  #workerHardwareTier = "large-k8s",
                  #workerStorageMB = 5
                #),
                #environmentId = "623131507a0af0281c01a699",
                #environmentRevisionSpec = "ActiveRevision | LatestRevision | SomeRevision(623131577a0af0281c01a69a)",
                #externalVolumeMountIds = array(
                  #"6231327c7a0af0281c01a69b",
                  #"623132867a0af0281c01a69c"
                #),
                # Domino's REST API accepts hardware tiers' *ID* only
                hardwareTier = toString(hardware_tiers[row, 3]),
                #mainRepoGitRef = list(
                  #refType = "head | commitId | tags | branches",
                  #value = "my-test-branch"
                #),
                projectId = project_id,
                runCommand = paste("aio.R", toString(row), sep = " "),
                #snapshotDatasetsOnCompletion = false,
                title = paste("Parallel R", toString(row), sep = " ")
              ),
              encode = "json")
}
