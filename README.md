# ChronicPainDWI

The starting point and aim of this project is to use diffusion MRI to improve our understanding of chronic pain and its treatment.


## Dataset

The dataset consists of 27 chronic low back pain patients and 25 controls scanned at three timepoints (0, 2, and 4 months) between April 2021 and July 2022. For complete information about the dataset and acquisition see ... 

All participants were imaged using a 3.0 T MRI scanner (Philips Ingenia, Siemens) across T1-weighted, BOLD, TOF, SWI and diffusion weighted contrasts. 

T1-weighted images (~ 5 min) were obtained using a MAG prepared (MP) Gradient Recalled (GR) sequence with repetition time (RT) = 7.9 ms, echo time (TE) = 3.5 ms, flip angle = 8°, voxel size 1.00mm x 1.00mm x 1.00mm. 

BOLD images: (~ 10 min) were obtained using a 2D segmented k-space (SK) Fat Saturation (FS) Gradient recalled (GR) sequence with repetition time (RT) = 1.075 s, echo time (TE) = 30 ms, flip angle = 55°, voxel size 3.00mm x 3.00mm x 3.00mm. For each subject 576 volumes were obtained including 1 reversed phase encoding (AP) volume for correcting susceptibility induced distortions. SENSE = 1.2 and multi band (MB) = 4

Diffusion-weighted images: (~ 9 min) were obtained using a 2D segmented k-space (SK) Fat Saturation (FS) Spin Echo (SE) sequence with repetition time (RT) = 4.800 s, echo time (TE) = 92 ms, flip angle = 90°, voxel size 2.00mm x 2.00mm x 2.00mm. For each subject 108 diffusion volumes (7 b = 0 mm2/s, 8 b = 300 mm2/s, 32 b = 1,000 mm2/s, 60 b = 2,000 mm2/s) were obtained including a b0 with reverse phase encoding (AP) for correction of susceptibility induced distortions. SENSE = 1.9


## Preprocessing and tractogram generation

In the [preprocessing](https://github.com/Tetreault-Pain-Imaging-Lab/ChronicPainDWI/tree/main/preprocessing) folder you will find scripts and information to run the first steps of the analysis. The main tool used for this part is [TractoFlow](https://tractoflow-documentation.readthedocs.io/en/latest/index.html) which does the preprocessing of the DWI files and generates tractograms.

inputs: Raw data in BIDS format (whole dataset)
outputs: DTI and fODF metrics, ... (tractoflow's result folder)


## Bundle segmentation 

In the [bundleseg](https://github.com/Tetreault-Pain-Imaging-Lab/ChronicPainDWI/tree/main/bundleseg) folder are scripts and information for the segmentation of the bundles computed using TractoFlow. The main tool used for this part is  the [RecobundlesX pipeline](https://github.com/scilus/rbx_flow)

inputs:  ...
outputs: ...


