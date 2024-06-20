# Tractometry 

After bundle segmentation, we ran tractometry using another scil lab pipeline : [tractometry_flow](https://github.com/scilus/tractometry_flow). Just like we did to run rbx_flow, we used combine_flow to setup the input directory structure. 

## combine_flows
We used the script `combineflow_for_tractometry_cc.sh` which simply calls the tree_for_rbx_flow.sh script from the [combine_flows](https://github.com/scilus/combine_flows) repository to create a directory on which we can run tractometry_flow directly. This directory should have the folowing structure before running tractometry_flow :

```
                            [tractometry]
                            ├── sub-001_ses-v1
                            │   ├── *lesion_mask.nii.gz (optional)
                            │   ├── *fodf.nii.gz (optional to generate fixel AFD)
                            │   ├── metrics
                            │   │   └── *.nii.gz
                            │   └── bundles
                            │       └── *.trk
                            ├── sub-001_ses-v2
                            │   └── ...
                            ├── sub-002_ses-v1
                            └── ...


```
combine_flows creates symlinks to the work folder containing the actual files created by tractoflow so make sure you haven't moved the /results or /work folder after running tractoflow and rbx.

## tractometry_flow

This pipeline allows you to extract tractometry information by combining
subjects's fiber bundles and diffusion MRI metrics.

<details><summary><b>Resources</b></summary>
  
- [GitHub repository](https://github.com/scilus/tractometry_flow)
- Should you use this pipeline for your research, **please cite the following**:

```
Cousineau, M., P-M. Jodoin, E. Garyfallidis, M-A. Cote, F.C. Morency, V. Rozanski, M. Grand'Maison, B.J. Bedell, and M. Descoteaux.
"A test-retest study on Parkinson's PPMI dataset yields statistically significant white matter fascicles."
NeuroImage: Clinical 16, 222-233 (2017) doi:10.1016/j.nicl.2017.07.020

Kurtzer GM, Sochat V, Bauer MW Singularity: Scientific containers for
mobility of compute. PLoS ONE 12(5): e0177459 (2017)
https://doi.org/10.1371/journal.pone.0177459

P. Di Tommaso, et al. Nextflow enables reproducible computational workflows.
Nature Biotechnology 35, 316–319 (2017) https://doi.org/10.1038/nbt.3820
```
</details>


<details><summary><b>Example command</b></summary>

```
nextflow run $my_main_nf \
    --input $my_input \
    -with-singularity $my_singularity_img -resume \
    --skip_projection_endpoints_metrics \
    --use_provided_centroids
```
</details>
the outputs structure should look like this:

```
            [results_tractometry]
            ├── Statistics
            │   ├── sub-001_ses-v1
            │   │   ├── Bundle_Endpoints_Map
            │   │   ├── Bundle_Label_And_Distance_Maps
            │   │   ├── Bundle_Length_Stats
            │   │   ├── Bundle_Streamline_Count
            │   │   ├── Bundle_Volume
            │   │   ├── Bundle_Volume_Per_Label
            │   │   ├── Color_Bundle
            │   │   ├── Remove_Invalid_Streamlines
            │   │   ├── Resample_Centroid
            │   │   └── Uniformize_Bundle  
            │   ├── sub-001_ses-v2
            │   │   └── ...
            │   ├── sub-002_ses-v1
            ...
```

