# Install packages
install.packages('remotes')
remotes::install_github('ohdsi/Eunomia')
remotes::install_github('ohdsi/PatientLevelPrediction')

#Create Demo OMOP CDM database and cohorts
connectionDetails <- Eunomia::getEunomiaConnectionDetails()
Eunomia::createCohorts(
  connectionDetails = connectionDetails,
  cdmDatabaseSchema = "main", 
  cohortDatabaseSchema = "main", 
  cohortTable = "cohort" 
  )

# Design Model
library(PatientLevelPrediction)
library(FeatureExtraction)
modelDesign <- list()
# first fit a LASSO logistic regression
modelDesign[[1]] <- createModelDesign(
  targetId = 4, 
  outcomeId = 3, 
  restrictPlpDataSettings = createRestrictPlpDataSettings(), 
  populationSettings = createStudyPopulationSettings(
    riskWindowStart = 1, 
    startAnchor = 'cohort start',
    riskWindowEnd = 365, 
    endAnchor = 'cohort start'
      ), 
  covariateSettings = createCovariateSettings(
    useDemographicsGender = T, 
    useDemographicsAgeGroup = T, 
    useConditionGroupEraLongTerm = T
    ), 
  
  featureEngineeringSettings = createFeatureEngineeringSettings(), 
  sampleSettings = createSampleSettings(), 
  preprocessSettings = createPreprocessSettings(), 
  modelSettings = setLassoLogisticRegression(), 
  splitSettings = createDefaultSplitSetting()
    )

# first fit a gradient boosting machine
modelDesign[[2]] <- createModelDesign(
  targetId = 4,
  outcomeId = 3, 
  restrictPlpDataSettings = createRestrictPlpDataSettings(), 
  populationSettings = createStudyPopulationSettings(
    riskWindowStart = 1, 
    startAnchor = 'cohort start',
    riskWindowEnd = 365, 
    endAnchor = 'cohort start'
  ), 
  covariateSettings = createCovariateSettings(
    useDemographicsGender = T, 
    useDemographicsAgeGroup = T, 
    useConditionGroupEraLongTerm = T
  ), 
  
  featureEngineeringSettings = createFeatureEngineeringSettings(), 
  sampleSettings = createSampleSettings(), 
  preprocessSettings = createPreprocessSettings(), 
  modelSettings = setGradientBoostingMachine(
    ntrees = 300, 
    nthread = 4, 
    maxDepth = c(3,7,10)
    ), 
  splitSettings = createDefaultSplitSetting()
)

databaseDetails <- createDatabaseDetails(
  connectionDetails = connectionDetails, 
  cdmDatabaseSchema = 'main', 
  cohortDatabaseSchema =  'main',
  cohortTable = 'cohort'
  )

model <- runMultiplePlp(
  databaseDetails = databaseDetails, 
  modelDesignList = list(modelDesign), 
  saveDirectory = file.path(getwd(), 'example_multiple_plp')
  )

viewMultiplePlp(file.path(getwd(), 'example_multiple_plp'))
