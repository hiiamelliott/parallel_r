#devtools::install_github("hrbrmstr/curlconverter")

library(curlconverter)
library(data.table)

api_proxy <- Sys.getenv("DOMINO_API_PROXY")
project_id <- Sys.getenv("DOMINO_PROJECT_ID")

hardware_tiers <- fread("/mnt/code/job_hardware_tiers.csv", header = FALSE)
for (row in 1:nrow(hardware_tiers)){
  # Call Domino's REST API via the API proxy to launch jobs
  # The API proxy is available in Domino workspaces and jobs
  # https://<your-deployment-url>/assets/lib/swagger-ui/index.html?url=<your-deployment-url>/assets/swagger.json#/Jobs/startJob
  httr::POST(paste0(api_proxy, '/v4/jobs/start'),
              accept_json(),
              body = list(
                projectId = project_id,
                commandToRun = paste("aio.R", toString(row), sep = " "),
                #commitId = "string",
                #mainRepoGitRef = list(
                #type = "string",
                 #value = "string"
                #),
                overrideHardwareTierId = toString(hardware_tiers[row, 3]),
                #onDemandSparkClusterProperties = list(
                  #computeEnvironmentId = "string",
                  #executorCount = 0,
                  #executorHardwareTierId = "string",
                  #executorStorage = list(
                    #value = 0,
                    #unit = "B"
                  #),
                  #masterHardwareTierId = "string",
                #),
                #computeClusterProperties = list(
                  #clusterType = "Spark",
                  #computeEnvironmentId = "string",
                  #masterHardwareTierId = list(
                    #value = "string"
                  #),
                  #workerCount = 0,
                  #maxWorkerCount = 0,
                  #workerHardwareTierId = list(
                    #value = "string"
                  #),
                  #workerStorage = list(
                    #value = 0,
                    #unit = "B"
                   #),
                  #extraConfigs = list(
                    #additionalProp1 = "string",
                    #additionalProp2 = "string",
                    #additionalProp3 = "string"
                  #)
                #),
                #environmentId = "string",
                #externalVolumeMounts = array(
                  #"string"
                #),
                #overrideVolumeSizeGiB = 0,
                title = paste("Parallel R", toString(row), sep = " ")
                #snapshotDatasetsOnCompletion = false
              ),
            encode = "json")
}
