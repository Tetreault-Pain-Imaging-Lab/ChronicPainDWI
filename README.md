# ChronicPainDWI

The starting point and aim of this project is to use diffusion MRI to improve our understanding of chronic pain and its treatment.


## Dataset
 
The dataset consists of 27 chronic low back pain patients and 25 controls scanned at three timepoints (0, 2, and 4 months) between April 2021 and July 2022. For complete information about the dataset and acquisition see [here](https://github.com/Tetreault-Pain-Imaging-Lab/dataset_LongitudinalNoTreatement)

All participants were imaged using a 3.0 T MRI scanner (Philips Ingenia, Siemens) across T1-weighted, BOLD, TOF, SWI and diffusion weighted contrasts. 

## How to use this repository
This repository was made for two reasons:
1. To document the analysis of the DMRI data of the mentionned dataset done in our lab. All the different parameters used at every step of the processing and analysis are presented in the scripts of this repository.
   
3. To facilitate reproduction of our results or similar analysis for new data.

It is made to be run on a Compute Canada Server, so if anyone intends to use these scripts locally or on another HPC, more significant adaptation of the scripts will be needed.


### For use on Compute Canada
If you intend to use this repository on Compute Canada here is some useful information :  
The utils folder contains scripts to facilitate the organization of the workspace and the installation of the different tools needed for the analysis on a Compute Canada cluster. 
We recommend that you put a version of your data on your scratch directory, run the scripts on the scratch and only tranfer the results somewhere else afterwards. On the other hand, tools like tractoflow and the scilus container should be in a directory that won't be periodically purged like the *projects* directory.

...


## Preprocessing and tractogram generation

In the [tractoflow](https://github.com/Tetreault-Pain-Imaging-Lab/ChronicPainDWI/tree/main/preprocessing) folder you will find scripts and information to run the first steps of the analysis. The main tool used for this part is [TractoFlow](https://tractoflow-documentation.readthedocs.io/en/latest/index.html) which does the preprocessing of the DWI files and generates tractograms.


## Bundle segmentation 

The second step is bundle segmentation. In the [bundleseg](https://github.com/Tetreault-Pain-Imaging-Lab/ChronicPainDWI/tree/main/bundleseg) folder are scripts and information for the segmentation of the bundles computed using TractoFlow. The main tool used for this part is  the [RecobundlesX pipeline](https://github.com/scilus/rbx_flow) 


## Tractometry 

The third step is tractometry which is done using another scilus lab tool : [tractometry_flow](https://github.com/scilus/tractometry_flow) 

## Statisical analysis ?

...



...

