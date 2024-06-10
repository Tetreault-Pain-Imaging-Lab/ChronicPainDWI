# Preprocessing

Preprocessing of the MRI was applied to the DWI and T1-w images using [TractoFLow](https://tractoflow-documentation.readthedocs.io/en/latest/index.html). Overall, DWI preprocessing is aimed at preparing the images for the application of local reconstruction models. It mainly consists of the following elements: denoising, artifact correction (eddy current/Foucault currents, motion, susceptibility Topup, truncation/Gibbs ringing), brain extraction, N4 bias correction, cropping, normalization, and resampling. On the other hand, preprocessing of the T1-w images is aimed at calculating tissue maps, seeding masks, and brain parcellations. Its main steps include denoising, brain extraction, N4 bias correction, cropping, and resampling.

## TractoFlow
TractoFlow was run directly on the BIDS formatted dataset on Compute Canada using the `run_tractoflow_cc.sh` script. For easy installation of tractoflow on a Compute Canada cluster, see the [utils](https://github.com/Tetreault-Pain-Imaging-Lab/ChronicPainDWI/tree/main/utils) section and the `install_tools` script.
 

*We had a problem with local tracking when not using the use_gpu profile that was resolved by adding the `--local_batch_size_gpu 0` line to the command but it should not be necessary to add this line. This might be fixed in newer versions. date: 2024-05-24*

<details><summary><b>Resources</b></summary>

  * [Gihub repository](https://github.com/scilus/tractoflow/)
  * [SCIL TractoFlow documentation](https://scil-documentation.readthedocs.io/en/latest/our_tools/tractoflow.html)
  * [ReadTheDocs TractoFlow documentation](https://tractoflow-documentation.readthedocs.io/en/latest/index.html)
  * `Theaud, G., Houde, J.-C., Boré, A., Rheault, F., Morency, F., Descoteaux, M.,TractoFlow: A robust, efficient and reproducible diffusion MRI pipeline leveraging Nextflow & Singularity, NeuroImage, https://doi.org/10.1016/j.neuroimage.2020.116889.`
</details>

<details><summary><b>Example command</b></summary>
  
  `nextflow run main.nf --input <DATASET_ROOT_FOLDER> --dti_shells "0 300 1000" --fodf_shells "0 1000 1200" -with-singularity <PATH_TO_scilus_img>`

See run_tractoflow_cc.sh for an example of how to use on a cluster.

</details>
  
<details><summary><b>Outputs</b></summary>
 
(The pipeline creates 2 folders: results and work. The files in results are symlinks to files in work. We highly recommend to not remove work folder. See [here](https://tractoflow-documentation.readthedocs.io/en/latest/pipeline/results.html) to transfert or copy-paste the results folder.)
  
**DTI metrics**: The Diffusion Tensor Imaging metrics computed are: the axial diffusivity (AD), fractional anisotropy (FA), geodesic anisotropy (GA), mean diffusivity (MD), radial diffusivity (RD), tensor, tensor norm, tensor eigenvalues, tensor eigenvectors, tensor mode, color-FA. Use flag `-dti_shell` to specify the desired shells t compute DTI metrics. Usually it is recommended to compute DTI metrics using b-values under $b = 1200 mm^2/s$.
  
**fODF metrics**: The fiber Orientation Distribution Function metrics computed are: the total and maximum Apparent Fiber Density (AFD), the Number of Fiber Orientation (NuFO) and principal fODFs orientations (up to 5 per voxel). Use flag `–fodf_shells` to specify the desired shells to compute fODF metrics and flag --sh_order to specify the spherical harmonic order (default is 8). Usually it is recommended to compute fODF metrics using b-values above $b = 700 mm^2/s$. 

</details>


