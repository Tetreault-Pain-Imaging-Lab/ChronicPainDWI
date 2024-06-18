
## QualityControl
Using the *dmri_qc* nextflow pipeline it is possible to check DWIs and the processed DWIs. A more in depth description and installation intruction can be found [here](https://scil-documentation.readthedocs.io/en/latest), but if you used the install_tools_cc.sh script, everything should be set. 
The script `run_dmriqc_cc.sh` can be used to run qc on different kinds of output using the -profile option of dmriqc_flow. To learn more about the different profiles you can use, see the `USAGE` file on the github page of dmriqc_flow.

<details><summary><b>Resources</b></summary>
  
  * [Github repository for python](https://github.com/scilus/dmriqcpy)
  * [Github repository for nextflow](https://github.com/scilus/dmriqc_flow)
</details>


<details><summary><b>Example command</b></summary>

`run_dmriqc_cc.sh`  on tractoflow outputs :
```
sbatch /home/ChronicPainDWI/qc/run_dmriqc_cc.sh tractoflow_qc_all

```

</details>


