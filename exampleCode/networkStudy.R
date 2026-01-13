## ------------------------------------------------------------------------------------------------------------------------------------------
#| label: setup
# Install required packages (uncomment if needed):
# install.packages(c("PatientLevelPrediction", "CohortGenerator", "CirceR", "remotes", "duckdb", "OHDSIShinyAppBuilder"))
# remotes::install_github("OHDSI/Strategus")
# remotes::install_github("OHDSI/OhdsiShinyModules"))

library(PatientLevelPrediction)
library(Strategus)

seed <- 42


## ------------------------------------------------------------------------------------------------------------------------------------------
dbPath <- "~/database/database-1M_filtered.duckdb"


## ------------------------------------------------------------------------------------------------------------------------------------------
cdmSchema <- "main"
workSchema <- "cohorts"
cohortTable <- "cohort_table"


## ------------------------------------------------------------------------------------------------------------------------------------------
#| label: cohort-generation
targetFile <- "./cohorts/31_[T] Pandemic Prediction new target.json"
outcomeFile <- "./cohorts/14_[O] Pandemic Prediction outcome pneumonia in hospital.json"

cohortDefinitions <- CohortGenerator::createEmptyCohortDefinitionSet()
cohortDefinitions[1, ] <- list(
  cohortId = 1,
  cohortName = "Target",
  sql = "",
  json = readChar(targetFile, file.info(targetFile)$size)
)
cohortDefinitions[2, ] <- list(
  cohortId = 2,
  cohortName = "Outcome",
  sql = "empty",
  json = readChar(outcomeFile, file.info(outcomeFile)$size)
)

cohortGeneratorModule <- CohortGeneratorModule$new()
cohortDefShared <- cohortGeneratorModule$createCohortSharedResourceSpecifications(cohortDefinitions)

cohortGeneratorModuleSpecifications <- cohortGeneratorModule$createModuleSpecifications(
  generateStats = TRUE
)


## ------------------------------------------------------------------------------------------------------------------------------------------
#| label: plp-design

covariateSettings <- FeatureExtraction::createDefaultCovariateSettings()

populationSettings <- createStudyPopulationSettings(
  binary = TRUE,
  removeSubjectsWithPriorOutcome = TRUE,
  requireTimeAtRisk = FALSE,
  riskWindowStart = 1,
  riskWindowEnd = 30,
)

preprocessSettings <- createPreprocessSettings(
  minFraction = 0.001,
  normalize = TRUE,
  removeRedundancy = TRUE
)

splitSettings <- createDefaultSplitSetting(splitSeed = seed)

# Choose model based on parameter (baseline: lasso logistic)
modelSettings <- PatientLevelPrediction::setLassoLogisticRegression(seed = seed)
  # Other options (require additional packages; see Exercises below):
  # PatientLevelPrediction::setGradientBoostingMachine(ntrees = 100, seed = seed),
  # PatientLevelPrediction::setRandomForest(mtries = 10, seed = seed),
  # PatientLevelPrediction::setXgBoost(nrounds = 100, seed = seed),

message(sprintf("Model selected: %s | Split seed: %s", "LASSO", seed))

modelDesign <- PatientLevelPrediction::createModelDesign(
  targetId = 1,
  outcomeId = 2,
  populationSettings = populationSettings,
  covariateSettings = covariateSettings,
  preprocessSettings = preprocessSettings,
  modelSettings = modelSettings,
  splitSettings = splitSettings,
  runCovariateSummary = TRUE
)

plpModule <- PatientLevelPredictionModule$new()
plpModuleSpecs <- plpModule$createModuleSpecifications(modelDesignList = modelDesign)


## ------------------------------------------------------------------------------------------------------------------------------------------
#| label: analysis-specs

analysisSpecifications <- createEmptyAnalysisSpecifications() |>
  addSharedResources(cohortDefShared) |>
  addModuleSpecifications(cohortGeneratorModuleSpecifications) |>
  addModuleSpecifications(plpModuleSpecs)

ParallelLogger::saveSettingsToJson(analysisSpecifications, "analysisSpecifications.json")


## ------------------------------------------------------------------------------------------------------------------------------------------
#| label: execute
workFolder <- normalizePath("./results/strategus/work")
resultsFolder <- normalizePath("./results/strategus/results")

executionSettings <- Strategus::createCdmExecutionSettings(
  workDatabaseSchema = workSchema,
  cdmDatabaseSchema = cdmSchema,
  cohortTableNames = CohortGenerator::getCohortTableNames(cohortTable = cohortTable),
  workFolder = workFolder,
  resultsFolder = resultsFolder,
  incremental = FALSE
)

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "duckdb",
  server = dbPath
)

# Execute the study (may take some minutes depending on data size)
Strategus::execute(
  analysisSpecifications,
  executionSettings = executionSettings,
  connectionDetails = connectionDetails
)


## ----eval=FALSE----------------------------------------------------------------------------------------------------------------------------
# analysisLocation <- file.path(workFolder, "PatientLevelPredictionModule")
# PatientLevelPrediction::viewMultiplePlp(analysisLocation)
# 

