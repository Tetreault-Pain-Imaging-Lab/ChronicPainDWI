# Bundle segmentation
After running tractoflow, the next step is bundle segmentation which is done using the the [*RecobundlesX* nextflow pipeline](https://scil-documentation.readthedocs.io/en/latest/our_tools/recobundles.html) (rbx_flow). This tool is used to extracts white matter fiber bundles of interest. In order to run *RecobundlesX*, the tractoflow results must be organized a certain way. To facilitate this organization we used [combine_flows](https://github.com/scilus/combine_flows/blob/main/tree_for_bst_flow.sh)

## combine_flows
...

## RecobundlesX
The script used to lauch this pipeline is `run_rbx_cc.sh`

<details><summary><b>Resources</b></summary>

  * [Github repository](https://github.com/scilus/rbx_flow)
  * [SCIL RecobundleX documentation](https://scil-documentation.readthedocs.io/en/latest/our_tools/recobundles.html)
  * [Example atlases](https://zenodo.org/record/4104300#.YmMEk_PMJaQ)
  * `Rheault, Francois. Analyse et reconstruction de faisceaux de la matière blanche.
page 137-170, (2020), https://savoirs.usherbrooke.ca/handle/11143/17255`
</details>

<details><summary><b>Example command</b></summary>
  
`nextflow run main.nf -resume -with-singularity scilus-1.2.0_rbxflow-1.1.0.img --input input/ --atlas_config code/rbx-atlas/config.json --atlas_anat code/rbx-atlas/mni_masked.nii.gz --atlas_directory code/rbx-atlas/atlas/`
</details>
