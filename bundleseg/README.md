# Bundle segmentation
After running tractoflow, the next step is bundle segmentation which is done using the the [*RecobundlesX* nextflow pipeline](https://scil-documentation.readthedocs.io/en/latest/our_tools/recobundles.html) (rbx_flow). This tool is used to extracts white matter fiber bundles of interest. In order to run *RecobundlesX*, the tractoflow results must be organized a certain way. To facilitate this organization we used [combine_flows](https://github.com/scilus/combine_flows/blob/main/tree_for_bst_flow.sh).

## combine_flows
We used the script `combineflow_for_rbx_cc.sh` which simply calls the tree_for_rbx_flow.sh script from the [combine_flows](https://github.com/scilus/combine_flows) repository to create a directory on which we can run rbx_flow directly. This directory should have the folowing structure before running RecobundlesX :

```
                                        [rbx]
                                        ├── sub-001_ses-v1
                                        │   ├── *fa.nii.gz
                                        │   └── *tracking.trk
                                        └── sub-001_ses-v2
                                        │    ...
                                        └── sub-002_ses-v2 
```
combine_flows creates symlinks to the work folder containing the actual files created by tractoflow so make sure you haven't moved the /results or /work folder after running tractoflow.

<details><summary><b>Resources</b></summary>

  * [Github repository](https://github.com/scilus/combine_flows)
    
</details>


## RecobundlesX
The script used to lauch this pipeline is `run_rbx_cc.sh`. It uses the atlas recommended by the scilus lab ([version 3.1 on zenodo](https://zenodo.org/records/10103446) ). The script `install_tools_cc.sh` presented in [utils](https://github.com/Tetreault-Pain-Imaging-Lab/ChronicPainDWI/tree/main/utils) automatically downloads the atlas files in a format that is ready to be used as the `--atlas_directory` option in the command line of rbx_flow. 

The path to the folder containing atlas should look like this :
```
                                      [atlas_dir]
                                        ├── atlas
                                        │   └── pop_average
                                        ├── centroids
                                        ├── config_fss_1.json
                                        ├── config_fss_2.json
                                        └── mni_masked.nii.gz
```

<details><summary><b>Resources</b></summary>

  * [Github repository](https://github.com/scilus/rbx_flow)
  * [SCIL RecobundleX documentation](https://scil-documentation.readthedocs.io/en/latest/our_tools/recobundles.html)
  * [Example atlases](https://zenodo.org/record/4104300#.YmMEk_PMJaQ)
  * `Rheault, Francois. Analyse et reconstruction de faisceaux de la matière blanche.
page 137-170, (2020), https://savoirs.usherbrooke.ca/handle/11143/17255`
</details>

<details><summary><b>Example command</b></summary>
  
```
nextflow run $my_main_nf \
    --input $my_input \
    -with-singularity $my_singularity_img \
    -with-report report.html \
    --atlas_directory $my_atlas_dir \
    -resume
```
</details>

<details><summary><b>Outputs</b></summary>
  
the outputs structure should look like this:
```
               [results_rbx]
            │   ├── sub-001_ses-v1
            │   │   ├── Clean_Bundles
            │   │   ├── Recognize_Bundles
            │   │   ├── Register_Anat
            │   │   └── Transform_Centroids
            │   ├── sub-001_ses-v2
            │   │   └── ...
            │   ├── sub-002_ses-v1
...
```

</details>
