# ChronicPainDWI

## Overview

**ChronicPainDWI** aims to leverage diffusion MRI to enhance our understanding of chronic pain mechanisms and improve treatment outcomes. This project focuses on the analysis and documentation of a unique dataset involving chronic low back pain patients.

## Dataset

The dataset includes 27 chronic low back pain patients and 25 controls scanned at three timepoints (0, 2, and 4 months) between April 2021 and July 2022. For detailed dataset and acquisition information, refer to our [dataset documentation](https://github.com/Tetreault-Pain-Imaging-Lab/dataset_LongitudinalNoTreatement).

All participants were scanned using a 3.0 T MRI scanner (Philips Ingenia, Siemens), across various contrasts including T1-weighted, BOLD, TOF, SWI, and diffusion-weighted imaging.

## Repository Usage

This repository serves two main purposes:
1. **Document Analysis**: It contains scripts for the analysis of the DMRI data, detailing parameters used at each processing and analysis step.
2. **Facilitate Reproduction**: Enables reproduction of our results or similar analyses on new data.

### Running on Compute Canada

If using this repository on Compute Canada, here's some helpful guidance:
- **Workspace Organization**: Use the `utils` folder for scripts to organize your workspace and install necessary tools.
- **Data Management**: Place your data in the scratch directory, run scripts there, and transfer results elsewhere only after processing.
    (When moving results folder be carefull of symlinks. For example, the results folder of tractoflow contains symlinks that points to files in the work folder. To copy        and paste results from one directory to another you can use the rsync command.
  
    Copy and paste results (replacing symlinks with actual files):
    ```bash
    rsync -rL user@graham.computecanada.ca:/home/user/scratch/data/2024-05-27_tractoflow/results /home/user/projects/tpil_data/2024-05-27_tractoflow/
    ```
    Preserving symlinks (the links must point to accessible files)
    ```bash
    rsync -rl user@graham.computecanada.ca:/home/user/scratch/data/2024-05-27_tractoflow/results /home/user/scratch/data/2024-05-27_tractoflow/
    ```

- **Tool Installation**: Install tools like `tractoflow` and the `scilus` container in a persistent directory (e.g., *projects* directory). Use the `install_tools_cc.sh` in     the utils folder to install them in one step.

- **Ressources allocation**:When submitting jobs on a cluster, you have to allocate ressources. To monitor jobs and see what ressources it uses, Narval and Beluga have a portal that helps you visualise ressources usage for tasks :[Narval](https://portail.narval.calculquebec.ca), [Beluga](https://portail.beluga.calculquebec.ca).
Portals for the other clusters might be available now.


## Analysis Workflow

### Preprocessing and tractogram generation

In the [tractoflow](https://github.com/Tetreault-Pain-Imaging-Lab/ChronicPainDWI/tree/main/preprocessing) folder you will find scripts and information to run the first steps of the analysis. The main tool used for this part is [TractoFlow](https://tractoflow-documentation.readthedocs.io/en/latest/index.html) which does the preprocessing of the DWI files and generates tractograms.


### Bundle segmentation 

The second step is bundle segmentation. In the [bundleseg](https://github.com/Tetreault-Pain-Imaging-Lab/ChronicPainDWI/tree/main/bundleseg) folder are scripts and information for the segmentation of the bundles computed using TractoFlow. The main tool used for this part is  the [RecobundlesX pipeline](https://github.com/scilus/rbx_flow) 


### Tractometry 

The third step is tractometry which is done using another scilus lab tool : [tractometry_flow](https://github.com/scilus/tractometry_flow) 

### Statisical analysis ?

...



...

