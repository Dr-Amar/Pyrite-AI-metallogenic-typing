# Artificial Intelligence-Driven Metallogenic Typing of Pyrite

## Graphical Abstract

![Graphical abstract: AI-driven metallogenic typing of pyrite](reports/figures/graphical_abstract.jpg)


Machine-learning workflow for classifying pyrite trace-element geochemistry from global ore systems. The repository supports the paper:

> Gul, M.A. et al. (2026). **Artificial intelligence-driven metallogenic typing of pyrite from global ore systems.** *Journal of Geochemical Exploration*, 289, 108138. https://doi.org/10.1016/j.gexplo.2026.108138

![Model performance heatmaps](reports/figures/model_performance_heatmaps_4panel.png)

## Scientific objective

Pyrite trace-element systematics can preserve information about ore-fluid source, physicochemical conditions, temperature, and metallogenic environment. This workflow applies supervised machine-learning models to classify pyrite from global ore systems using multielement LA-ICP-MS data.

## Models included

- **Random Forest (RF)**
- **Support Vector Machine (SVM)** with RBF kernel
- **Gradient Boosting (GB)**
- **Multilayer Perceptron (MLP)**

The workflow compares the standard dataset with oversampled and undersampled datasets, then reports validation/test accuracy, AUC, confusion matrices, and class-level precision/recall/F1.

## Feature set

The notebooks use the following pyrite trace-element features:

```text
Co, Ni, Cu, Zn, Se, Ag, Sb, Pb, Bi, As
```

Target column:

```text
Deposit type
```

Deposit classes represented in the study include orogenic gold, VMS, SEDEX, porphyry, skarn, and barren/sedimentary pyrite.

## Repository structure

```text
.
├── data/
│   ├── raw/                         # Raw compilation; not included in public-safe release

## Graphical Abstract

![Graphical abstract: AI-driven metallogenic typing of pyrite](reports/figures/graphical_abstract.jpg)
│   └── processed/                   # Standardized input data; private release only

## Graphical Abstract

![Graphical abstract: AI-driven metallogenic typing of pyrite](reports/figures/graphical_abstract.jpg)
├── notebooks/
│   ├── 00_log_transform_and_standardize.ipynb
│   ├── 01_preprocessing_and_model_checks.ipynb
│   ├── 02_random_forest.ipynb
│   ├── 03_support_vector_machine.ipynb
│   ├── 04_gradient_boosting.ipynb
│   ├── 05_multilayer_perceptron.ipynb
│   └── 06_model_performance_heatmaps.ipynb
├── reports/figures/
│   └── model_performance_heatmaps_4panel.png
├── src/pyrite_typing/
│   ├── __init__.py
│   └── config.py
├── requirements.txt
├── environment.yml
├── CITATION.cff
├── DATA_ACCESS.md
├── REPRODUCIBILITY_NOTES.md
└── github_setup_commands.md
```

## Quick start

### 1. Create environment

```bash
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate

## Graphical Abstract

![Graphical abstract: AI-driven metallogenic typing of pyrite](reports/figures/graphical_abstract.jpg)
pip install -r requirements.txt
```

Or with conda/mamba:

```bash
conda env create -f environment.yml
conda activate pyrite-typing
```

### 2. Add data

Place the standardized input file here:

```text
data/processed/Pyrite_Standarized_data_file_New_Paper.xlsx
```

For a public repository, do **not** upload the full compiled dataset unless all co-author, publisher, and source-data permissions are clear. Use the private repository first.

### 3. Run notebooks

Open notebooks in order:

```bash
jupyter lab
```

Suggested execution order:

1. `00_log_transform_and_standardize.ipynb`
2. `02_random_forest.ipynb`
3. `03_support_vector_machine.ipynb`
4. `04_gradient_boosting.ipynb`
5. `05_multilayer_perceptron.ipynb`
6. `06_model_performance_heatmaps.ipynb`

## Reported performance summary

The paper reports that SMOTE-balanced training produced the strongest validation/test performance overall, with SVM and MLP reaching the highest accuracy range and AUC values near 0.998 in the best cases.

| Dataset | Strongest validation accuracy | Strongest test accuracy | Notes |
|---|---:|---:|---|
| Standard | SVM ~93.09% | SVM ~92.99% | Stable baseline performance |
| SMOTE | SVM ~97.68% | SVM/MLP ~97.7% / ~97.6% | Best overall accuracy/AUC |
| RUS/RUC-style undersampling | SVM/MLP/GB ~85–86% | GB/RF ~84–85% | Lower performance due to information loss |

## Important reproducibility note

The current uploaded notebooks implement `RandomUnderSampler` from `imbalanced-learn`. If the final published wording uses **RUC / cluster-based undersampling**, the public repository should either:

1. implement the exact cluster-based undersampling method, or  
2. rename this workflow consistently as **random undersampling (RUS)**.

This should be corrected before making the repository public.

## Citation

Please cite the article if you use this workflow:

```bibtex
@article{Gul2026PyriteMetallogenicTyping,
  title = {Artificial intelligence-driven metallogenic typing of pyrite from global ore systems},
  author = {Gul, Muhammad Amar and Kanwal, Asia and Faisal, Mohamed and Zafar, Tehseen and Awan, Rizwan Sarwar and Akhtar, Shamim and Khan, Ibrar and Yang, Xiaoyong},
  journal = {Journal of Geochemical Exploration},
  volume = {289},
  pages = {108138},
  year = {2026},
  doi = {10.1016/j.gexplo.2026.108138}
}
```

## License

This draft repository includes an MIT license for code. Review data-sharing permissions before public release of the dataset.

