
## QualityControl
Using the *dmri_qc* nextflow pipeline it is possible to check DWIs and the processed DWIs. A more in depth description and installation intruction can be found [here](https://scil-documentation.readthedocs.io/en/latest/our_tools/other_pipelines.html). 

<details><summary><b>Resources</b></summary>
  
  * [Github repository for python](https://github.com/scilus/dmriqcpy)
  * [Github repository for nextflow](https://github.com/scilus/dmriqc_flow)
</details>


<details><summary><b>Example command</b></summary>

`nextflow run dmriqc-flow-0.1.2/main.nf -profile -profile tractoflow_qc_all --input <TRACTOFLOW_RESULTS_FOLDER> \
    -with-singularity  <PATH_TO_scilus_img> -resume --raw_dwi_nb_threads 10`
</details>

