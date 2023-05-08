# Install packages
install.packages('remotes')
remotes::install_github('ohdsi/Eunomia')
remotes::install_github('ohdsi/PatientLevelPrediction')

# install mini-conda if you do not have conda already installed
reticulate::install_miniconda()
# running configurePython will install the python packages you need
PatientLevelPrediction::configurePython(envname = 'r-reticulate')

# if this works you should now have a bunch of classifiers
# that use python as the backend (randomForest, neural network,
# adaBoost, SVM)

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
# first run the standard LASSO Logistic regression
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

# next run a random forest
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
  modelSettings = setRandomForest(
    ntrees = list(500), 
    maxDepth = list(3,7,10,14),
    mtries =  list('sqrt')
    ), 
  splitSettings = createDefaultSplitSetting()
)

# next run an adaBoost
modelDesign[[3]] <- createModelDesign(
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
  modelSettings = setAdaBoost(
    nEstimators = list(200)
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
  modelDesignList = modelDesign, 
  saveDirectory = file.path(getwd(), 'example_python_plp')
  )

viewMultiplePlp(file.path(getwd(), 'example_python_plp'))
