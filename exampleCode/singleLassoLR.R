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
modelDesign <- createModelDesign(
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

databaseDetails <- createDatabaseDetails(
  connectionDetails = connectionDetails, 
  cdmDatabaseSchema = 'main', 
  cohortDatabaseSchema =  'main',
  cohortTable = 'cohort'
  )

model <- runMultiplePlp(
  databaseDetails = databaseDetails, 
  modelDesignList = list(modelDesign), 
  saveDirectory = file.path(getwd(), 'example_plp')
  )

viewMultiplePlp(file.path(getwd(), 'example_plp'))
