# Preprocessing

Preprocessing of the MRI was applied to the DWI and T1-w images using [TractoFLow](https://tractoflow-documentation.readthedocs.io/en/latest/index.html). Overall, DWI preprocessing is aimed at preparing the images for the application of local reconstruction models. It mainly consists of the following elements: denoising, artifact correction (eddy current/Foucault currents, motion, susceptibility Topup, truncation/Gibbs ringing), brain extraction, N4 bias correction, cropping, normalization, and resampling. On the other hand, preprocessing of the T1-w images is aimed at calculating tissue maps, seeding masks, and brain parcellations. Its main steps include denoising, brain extraction, N4 bias correction, cropping, and resampling.

## TractoFlow
Once you have all the tools installed (see the [`install_tools_cc.sh` script](https://github.com/Tetreault-Pain-Imaging-Lab/ChronicPainDWI/tree/main/install_tools_cc.sh) ) TractoFlow can be run directly on the BIDS formatted dataset on Compute Canada using the `run_tractoflow_cc.sh` script. 

the structure of the input data should look like :

```

--input=/path/to/[root]             Root folder containing multiple subjects

    [root]
    ├── S1
    │   ├── *dwi.nii.gz
    │   ├── *bval
    │   ├── *bvec
    │   ├── *rev_b0.nii.gz  (optional)
    │   ├── *aparc+aseg.nii.gz  (optional)
    │   ├── *wmparc.nii.gz  (optional)
    │   └── *t1.nii.gz
    └── S2
        ├── *dwi.nii.gz
        ├── *bval
        ├── *bvec
        ├── *rev_b0.nii.gz  (optional)
        ├── *aparc+aseg.nii.gz  (optional)
        ├── *wmparc.nii.gz  (optional)
        └── *t1.nii.gz

```
For longitudinal datasets with multiple sessions per subject, there should be a session subfolder in each subject folder containing the needed files.

### To run 
 To lauch `run_tractoflow_cc.sh`, cd into the repo's directory and use :
```
bash tractoflow/run_tractoflow_cc.sh your_config.sh
```
Replace your_config.sh with your actual config file. If you don't plan on running the pielines with multiple dataset, you could modify the `run_tractoflow_cc.sh` script to change the default config file to your config file.

In our script we use the following option :
```
--bidsignore $my_bidsignore \
```
This allows the bids validation to skip some files that you don't need. In our case the .bidsignore_tractoflow file contains only one line :
```
sub-*/ses-v*/fmap/sub-*_ses*_acq-rest*
```

*We had a problem with local tracking when not using the use_gpu profile that was resolved by adding the `--local_batch_size_gpu 0` line to the command but it should not be necessary to add this line. This might be fixed in newer versions. date: 2024-05-24*

<details><summary><b>Resources</b></summary>

  * [Gihub repository](https://github.com/scilus/tractoflow/)
  * [SCIL TractoFlow documentation](https://scil-documentation.readthedocs.io/en/latest/our_tools/tractoflow.html)
  * [ReadTheDocs TractoFlow documentation](https://tractoflow-documentation.readthedocs.io/en/latest/index.html)
  * `Theaud, G., Houde, J.-C., Boré, A., Rheault, F., Morency, F., Descoteaux, M.,TractoFlow: A robust, efficient and reproducible diffusion MRI pipeline leveraging Nextflow & Singularity, NeuroImage, https://doi.org/10.1016/j.neuroimage.2020.116889.`
</details>

<details><summary><b>Example command</b></summary>
  
  `nextflow run main.nf --input <DATASET_ROOT_FOLDER> --dti_shells "0 300 1000" --fodf_shells "0 1000 1200" -with-singularity <PATH_TO_scilus_img>`


</details>
  
<details><summary><b>Outputs</b></summary>
 
The pipeline creates 2 folders: results and work. The files in results are symlinks to files in work. We highly recommend to not remove work folder. See [here](https://tractoflow-documentation.readthedocs.io/en/latest/pipeline/results.html) to transfert or copy-paste the results folder.
  

</details>


