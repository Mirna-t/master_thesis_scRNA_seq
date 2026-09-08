# Master Thesis: scRNA-seq Analysis with Scanpy and Seurat

This repository contains the workflows and supplementary materials for a master's thesis comparing single-cell RNA sequencing analyses performed with **Scanpy** (Python) and **Seurat** (R).

## Repository structure

- [`scRNA_sequencing_scMixology_benchmarking/`](scRNA_sequencing_scMixology_benchmarking/) — Scanpy and Seurat V0–V9 workflows for the scMixology benchmark dataset.
- [`scRNA_sequencing_of_murine_intestinal_epithelial/`](scRNA_sequencing_of_murine_intestinal_epithelial/) — mIEC workflows, including unintegrated analyses and Harmony/CCA integration.
- [`supplementary_materials/`](supplementary_materials/) — Supplementary results and Python/R environment files.

## Reproducibility

```bash
conda env create -f supplementary_materials/scRNA-python_environment.yml
conda env create -f supplementary_materials/scRNA-R_environment.yml

```




*The notebooks include executed outputs. Large notebooks may be provided as compressed .zip iles and should be extracted before use.
