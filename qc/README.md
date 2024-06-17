
## QualityControl
Using the *dmri_qc* nextflow pipeline it is possible to check DWIs and the processed DWIs. A more in depth description and installation intruction can be found [here](https://scil-documentation.readthedocs.io/en/latest), but if you used the install_tools_cc.sh script, everything should be set. 
In this folder there are personalized script to run qc on different kinds of output using the -profile option of dmriqc_flow. To learn more about the different profiles you can use, see the `USAGE` file on the github page of dmriqc_flow.

<details><summary><b>Resources</b></summary>
  
  * [Github repository for python](https://github.com/scilus/dmriqcpy)
  * [Github repository for nextflow](https://github.com/scilus/dmriqc_flow)
</details>


<details><summary><b>Example command</b></summary>

`nextflow run dmriqc-flow-0.1.2/main.nf -profile -profile tractoflow_qc_all --input <TRACTOFLOW_RESULTS_FOLDER> \
    -with-singularity  <PATH_TO_scilus_img> -resume --raw_dwi_nb_threads 10`
</details>


