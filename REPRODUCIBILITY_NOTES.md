# Reproducibility notes

## Changes made while preparing this GitHub draft

- Notebook outputs were cleared to keep the repository lightweight.
- Absolute local paths were replaced with repository-relative paths.
- The heatmap figure was copied to `reports/figures/`.
- Data files are excluded in the public-safe package by `.gitignore`.

## Algorithm naming check before public release

The uploaded notebooks use:

```python
from imblearn.under_sampling import RandomUnderSampler
```

If the manuscript/repository describes this as **RUC** or **Random Undersampling with Clustering**, confirm whether the intended method was actually cluster-based undersampling. If yes, implement it directly before release. If no, use the label **Random Under-Sampling (RUS)** consistently.

## Suggested public-release checklist

- [ ] Confirm repo name and visibility.
- [ ] Confirm code license.
- [ ] Confirm data release policy.
- [ ] Add co-author ORCID IDs if available.
- [ ] Add DOI badge once repository is archived on Zenodo.
- [ ] Run all notebooks from a clean environment.
- [ ] Compare reproduced metrics with the published heatmap.
