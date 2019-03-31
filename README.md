# Tutorial-PLP
Materials necessary for the "Patient-Level Prediction Tutorial".  

## Description & Objectives
This workshop is for researchers who want to design prediction studies for precision medicine and disease interception using the OHDSI tools and programmers who want to implement and execute prediction studies using the OHDSI methods library.

The participants will define their own prediction problem and will work on this as a group. The course starts with an introduction to Patient-Level Prediction, after which the OHDSI Framework is explained in detail. Driven by an actual use case the usage of the tools are demonstrated.

Course prerequisites: knowledge of OMOP CDM and Vocabularies and either 1) epidemiologic knowledge understanding of how to define cohorts or 2) R programming skills.

Participants are encouraged to watch these tutorials from past years in preparation for the tutorial:

CDM tutorial: https://github.com/Tutorial-CDM

Cohort definition: https://www.ohdsi.org/ohdsi-cohort-definition-and-phenotyping-tutorial-recording/

## Required Reading
* You will be trained to use the OHDSI PLP Framework described in this paper: Reps JM, Schuemie MJ, Suchard MA, Ryan PB, Rijnbeek PR. [Design and implementation of a standardized framework to generate and evaluate patient-level prediction models using observational healthcare data](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6077830/). J Am Med Inform Assoc. 2018;25(8):969-975)
* Furthermore, during the course, you will be participating in an exercise to review a published prediction model: the CHADS2 score for predicting stroke in patients with Atrial Fibrillation. Gage BF1, Waterman AD, Shannon W, Boechler M, Rich MW, Radford MJ. [Validation of clinical classification schemes for predicting stroke: results from the National Registry of Atrial Fibrillation.](https://jamanetwork.com/journals/jama/fullarticle/193912) JAMA. 2001 Jun 13;285(22):2864-70.

* You will evaluate the quality of the analysis and the completeness of the reporting of the model using the TRIPOD statement Collins GS, Reitsma JB, Altman DG, Moons KG.  [Transparent Reporting of a multivariable prediction model for Individual Prognosis Or Diagnosis (TRIPOD)](https://annals.org/aim/fullarticle/2088542/transparent-reporting-multivariable-prediction-model-individual-prognosis-diagnosis-tripod-explanation).  Ann Intern Med. 2015 May 19;162(10):735-6. doi: 10.7326/L15-5093-2.

## Recommended Reading:
A common area of confusion in the field is the difference between explanatory models – as would be used for causal inference in population-level effect estimation - and predictive models – as we are teaching you here to use for patient-level prediction.  The [paper](http://www.galitshmueli.com/system/files/MISQ-Predictive-Analytics-in-IS-Shmueli-Koppius%20-2011.pdf) by Shmueli and Koppius provides a nice summary of some of the conceptual distinctions in problem formulation, objective setting, model fitting, and results evaluation.

For those who prefer a [video](https://www.youtube.com/watch?v=whD2sYFHW8c) to a paper, here’s a nice presentation by Dr. Shmueli that covers most of the points in her paper.

Predictive models in observational data are becoming increasingly popular, but as a field, we are not consistently applying best practices in their execution or reporting.  This recent review by Goldstein et al evaluates the predictive models observed in the literature, highlighting common pitfalls that we hope to teach you to avoid, and offering suggestions that may resonate with you as you look to design and implement your own models or review literature from predictive models built by others.
Goldstein BA, Navar AM, Pencina MJ, Ioannidis JP.  [Opportunities and challenges in developing risk prediction models with electronic health records data: a systematic review.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5201180/)  J Am Med Inform Assoc. 2017 Jan;24(1):198-208. doi: 10.1093/jamia/ocw042. Epub 2016 May 17.


## Previously Recorded Tutorials
This tutorial has been given and recorded previously if you would like to preview it.

* [2018 OHDSI Symposium](https://www.ohdsi.org/past-events/patient-level-prediction/)
