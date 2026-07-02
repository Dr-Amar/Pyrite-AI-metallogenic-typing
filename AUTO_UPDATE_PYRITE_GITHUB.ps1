<#
AUTO_UPDATE_PYRITE_GITHUB.ps1

Purpose:
  Fully automates the public-safe GitHub polishing workflow for:
  https://github.com/Dr-Amar/Pyrite-AI-metallogenic-typing

What it does:
  1. Writes a clean enhanced README.md.
  2. Copies GA.jpg to reports/figures/graphical_abstract.jpg.
  3. Copies Methods.png to reports/figures/methods_workflow.png.
  4. Commits and pushes changes to the pyrite repository.
  5. Optionally updates GitHub About description, homepage, topics using GitHub CLI.
  6. Optionally updates the Dr-Amar profile README with a featured repository section.
  7. Optionally attempts to pin selected repositories using GitHub GraphQL via GitHub CLI.

Before running:
  - Git must be installed and working.
  - For GitHub metadata/profile updates, install GitHub CLI: https://cli.github.com/
  - Login once with: gh auth login
#>

[CmdletBinding()]
param(
    [string]$RepoRoot = "C:\Users\ROG\Downloads\pyrite-ai-metallogenic-typing-public-safe\pyrite-ai-metallogenic-typing-public-safe",
    [string]$GithubOwner = "Dr-Amar",
    [string]$RepoName = "Pyrite-AI-metallogenic-typing",
    [string]$CommitMessage = "Polish README, workflow figures, and GitHub metadata",
    [bool]$Push = $true,
    [bool]$UpdateRepoAbout = $true,
    [bool]$UpdateProfileReadme = $true,
    [bool]$AttemptProfilePins = $false,
    [string]$ProfileRepoPath = "$env:USERPROFILE\Downloads\Dr-Amar-profile-readme",
    [string]$GitUserName = "Dr-Amar",
    [string]$GitUserEmail = "amar_geologist@yahoo.com"
)

$ErrorActionPreference = "Stop"

function Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Ok($msg) { Write-Host "[OK] $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Fail($msg) { Write-Host "[ERROR] $msg" -ForegroundColor Red; throw $msg }

function HasCommand($name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

function Invoke-GitCommitIfNeeded([string]$Message, [bool]$DoPush) {
    git status --short
    git add .
    git diff --cached --quiet
    if ($LASTEXITCODE -eq 0) {
        Ok "No staged changes to commit."
    } else {
        git commit -m $Message
        if ($DoPush) {
            git push
            Ok "Changes pushed."
        } else {
            Warn "Push disabled. Commit created locally only."
        }
    }
}

function Ensure-GitIdentity {
    git config --global user.name $GitUserName
    git config --global user.email $GitUserEmail
    Ok "Git identity set to $GitUserName <$GitUserEmail>"
}

function Ensure-Remote([string]$Owner, [string]$Name) {
    $origin = git remote get-url origin 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($origin)) {
        git remote add origin "https://github.com/$Owner/$Name.git"
        Ok "Added origin remote."
    } else {
        Ok "Origin remote already exists: $origin"
    }
}

function Write-EnhancedReadme([string]$ReadmePath) {
$readme = @'
# Artificial Intelligence-Driven Metallogenic Typing of Pyrite from Global Ore Systems

[![DOI](https://img.shields.io/badge/DOI-10.1016%2Fj.gexplo.2026.108138-blue)](https://doi.org/10.1016/j.gexplo.2026.108138)
![Python](https://img.shields.io/badge/Python-3.9%2B-blue)
![Machine Learning](https://img.shields.io/badge/ML-RF%20%7C%20SVM%20%7C%20GB%20%7C%20MLP-green)
![Status](https://img.shields.io/badge/release-public--safe-brightgreen)

This repository supports the article:

> **Gul, M.A. et al. (2026). Artificial intelligence-driven metallogenic typing of pyrite from global ore systems. _Journal of Geochemical Exploration_, 289, 108138.**  
> https://doi.org/10.1016/j.gexplo.2026.108138

The repository provides a public-safe, reproducible machine-learning workflow for metallogenic typing of pyrite trace-element geochemistry from global ore systems.

---

## Graphical Abstract

![Graphical abstract: AI-driven metallogenic typing of pyrite](reports/figures/graphical_abstract.jpg)

---

## Overview

Pyrite is one of the most common sulfide minerals in ore systems and sedimentary environments. Its trace-element composition can preserve information about ore-fluid source, temperature, physicochemical conditions, metal budget, and metallogenic environment. However, traditional two-element and ternary discrimination diagrams commonly fail because pyrite from different ore systems can show strong compositional overlap.

This study develops an **AI-driven metallogenic typing framework** that classifies pyrite from global ore systems using multielement LA-ICP-MS trace-element data, supervised machine-learning models, class-balancing experiments, blind testing, deposit-scale validation, and interpretable geochemical analysis.

---

## Key scientific innovations

- **Global pyrite geochemical framework** for metallogenic typing across major ore-system classes.
- **Large multideposit compilation** of pyrite LA-ICP-MS spot analyses from global deposits and stratigraphic settings.
- **Multielement AI classification** using Co, Ni, Cu, Zn, Se, Ag, Sb, Pb, Bi, and As.
- **Direct comparison of four supervised ML models:** Random Forest, Support Vector Machine, Gradient Boosting, and Multilayer Perceptron.
- **Class-imbalance assessment** using standard data, SMOTE oversampling, and RUC/RUS-style undersampling.
- **Blind test evaluation** using independent test splits.
- **Deposit-scale LOGO cross-validation** to reduce overoptimistic performance caused by samples from the same deposit being split across training and testing sets.
- **Explainable geochemical interpretation** through feature importance, permutation importance, t-SNE visualization, box plots, and confusion-matrix analysis.
- **Interactive web application** for pyrite deposit-type prediction.

---

## Dataset summary

| Item | Description |
|---|---|
| Mineral | Pyrite |
| Analytical method | LA-ICP-MS trace-element geochemistry |
| Approximate dataset size | ~5200 pyrite spot analyses |
| Deposits / settings | 138 global deposits and stratigraphic settings |
| Classes | Orogenic gold, VMS, SEDEX, Porphyry, Skarn, Sedimentary/Barren pyrite |
| Feature elements | Co, Ni, Cu, Zn, Se, Ag, Sb, Pb, Bi, As |
| Target variable | Deposit type / metallogenic class |
| Public data status | Full compiled dataset is not included in this public-safe release; see `DATA_ACCESS.md` |

---

## Methodological workflow

![Methodological workflow for AI-driven pyrite metallogenic typing](reports/figures/methods_workflow.png)

---

## Machine-learning models

| Model | Role in the study |
|---|---|
| Random Forest (RF) | Tree-based ensemble model; strong baseline and feature-importance interpretation |
| Support Vector Machine (SVM-RBF) | Non-linear decision-boundary classifier for high-dimensional geochemical space |
| Gradient Boosting (GB) | Boosted ensemble model for complex nonlinear trace-element patterns |
| Multilayer Perceptron (MLP) | Neural-network classifier for nonlinear multielement relationships |

---

## Resampling strategy

Class imbalance is a major challenge in global mineral-geochemistry datasets because some deposit classes naturally have many more analyses than others. This repository documents three dataset strategies:

| Dataset strategy | Purpose |
|---|---|
| Standard dataset | Original class distribution used as the baseline |
| SMOTE dataset | Synthetic Minority Over-Sampling Technique used to improve minority-class learning |
| RUC/RUS-style undersampling | Majority-class reduction used to test the effect of balanced but information-reduced training data |

**Important note:** the current uploaded notebooks implement `RandomUnderSampler` from `imbalanced-learn`. If the final manuscript wording uses strict **RUC / cluster-based undersampling**, this repository should either implement the exact cluster-based approach or consistently describe the implementation as **RUS-style undersampling**.

---

## Model validation strategy

The workflow evaluates model performance using:

- validation accuracy
- test accuracy
- AUC / ROC-AUC
- precision, recall, and F1-score
- confusion matrices
- blind testing
- LOGO cross-validation at deposit scale
- feature-importance and permutation-importance analysis
- t-SNE visualization of deposit-type separation

The LOGO design is especially important because pyrite datasets often contain multiple analyses from the same deposit. Holding out one deposit at a time gives a more realistic test of generalization to unseen geological systems.

---

## Reported performance summary

![Model performance heatmaps](reports/figures/model_performance_heatmaps_4panel.png)

The study reports that SMOTE-balanced learning produced the strongest overall validation/test performance, with SVM and MLP reaching the highest accuracy range and very high AUC values.

| Dataset | Strongest validation accuracy | Strongest test accuracy | General interpretation |
|---|---:|---:|---|
| Standard | SVM ~93.09% | SVM ~92.99% | Strong baseline performance |
| SMOTE | SVM ~97.68% | SVM/MLP ~97.7% / ~97.6% | Best overall accuracy and AUC |
| RUC/RUS-style undersampling | SVM/MLP/GB ~85–86% | GB/RF ~84–85% | Lower performance due to majority-class information loss |

---

## Geological interpretation

The AI results are not only predictive; they also provide geochemical insight. Feature-ranking and t-SNE analyses show that elements such as **Ni, Pb, Sb, Se, Cu, and As** contribute strongly to pyrite metallogenic discrimination. These elements reflect differences in temperature, ore-fluid source, metal availability, sulfide partitioning, and sedimentary versus hydrothermal controls.

The approach helps overcome limitations of traditional Co-Ni and As-Co-Ni diagrams, where different pyrite genetic classes show substantial compositional overlap.

---

## Interactive web application

An interactive web application accompanies the study and allows users to upload pyrite trace-element compositions and predict metallogenic class using the trained ML workflow.

**Launch app:**  
https://huggingface.co/spaces/DrAmar/Pyrite_Discrimination

The input Excel sheet should follow the same feature-column sequence as the modelling dataset.

---

## Repository structure

```text
.
├── data/
│   ├── raw/                         # Raw compilation; not included in public-safe release
│   └── processed/                   # Standardized input data; private release only
├── notebooks/
│   ├── 00_log_transform_and_standardize.ipynb
│   ├── 01_preprocessing_and_model_checks.ipynb
│   ├── 02_random_forest.ipynb
│   ├── 03_support_vector_machine.ipynb
│   ├── 04_gradient_boosting.ipynb
│   ├── 05_multilayer_perceptron.ipynb
│   └── 06_model_performance_heatmaps.ipynb
├── reports/
│   └── figures/
│       ├── graphical_abstract.jpg
│       ├── methods_workflow.png
│       └── model_performance_heatmaps_4panel.png
├── src/
│   └── pyrite_typing/
│       ├── __init__.py
│       └── config.py
├── requirements.txt
├── environment.yml
├── CITATION.cff
├── DATA_ACCESS.md
├── REPRODUCIBILITY_NOTES.md
└── github_setup_commands.md
```

---

## Quick start

### 1. Clone repository

```bash
git clone https://github.com/Dr-Amar/Pyrite-AI-metallogenic-typing.git
cd Pyrite-AI-metallogenic-typing
```

### 2. Create Python environment

```bash
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

Or with conda/mamba:

```bash
conda env create -f environment.yml
conda activate pyrite-typing
```

### 3. Add data

Place the standardized input file here:

```text
data/processed/Pyrite_Standarized_data_file_New_Paper.xlsx
```

For a public repository, do **not** upload the full compiled dataset unless all co-author, publisher, and source-data permissions are clear.

### 4. Run notebooks

```bash
jupyter lab
```

Suggested execution order:

1. `00_log_transform_and_standardize.ipynb`
2. `01_preprocessing_and_model_checks.ipynb`
3. `02_random_forest.ipynb`
4. `03_support_vector_machine.ipynb`
5. `04_gradient_boosting.ipynb`
6. `05_multilayer_perceptron.ipynb`
7. `06_model_performance_heatmaps.ipynb`

---

## Data availability

This public-safe repository does not include the full standardized Excel dataset. The article states that data will be made available on request. See `DATA_ACCESS.md` for data-access guidance.

---

## Citation

Please cite the article if you use this workflow:

```bibtex
@article{Gul2026PyriteMetallogenicTyping,
  title   = {Artificial intelligence-driven metallogenic typing of pyrite from global ore systems},
  author  = {Gul, Muhammad Amar and Kanwal, Asia and Faisal, Mohamed and Zafar, Tehseen and Awan, Rizwan Sarwar and Akhtar, Shamim and Khan, Ibrar and Yang, Xiaoyong},
  journal = {Journal of Geochemical Exploration},
  volume  = {289},
  pages   = {108138},
  year    = {2026},
  doi     = {10.1016/j.gexplo.2026.108138}
}
```

---

## License

This repository includes an MIT license for code. Data-sharing permissions should be reviewed before public release of the compiled geochemical dataset.
'@

    Set-Content -Path $ReadmePath -Value $readme -Encoding UTF8 -NoNewline
    Ok "Enhanced README written: $ReadmePath"
}

function Update-RepoAbout([string]$Owner, [string]$Name) {
    if (-not (HasCommand "gh")) {
        Warn "GitHub CLI not found. Skipping repo About/topics update."
        Warn "Install from https://cli.github.com/ and run: gh auth login"
        return
    }

    gh auth status
    if ($LASTEXITCODE -ne 0) {
        Warn "GitHub CLI is not logged in. Run: gh auth login"
        return
    }

    $repo = "$Owner/$Name"
    Info "Updating GitHub About metadata for $repo"

    gh repo edit $repo `
        --description "AI-driven metallogenic typing of pyrite trace-element geochemistry from global ore systems using RF, SVM, GB, MLP, SMOTE/RUC, LOGO CV, and explainable ML." `
        --homepage "https://doi.org/10.1016/j.gexplo.2026.108138" `
        --add-topic "pyrite" `
        --add-topic "geochemistry" `
        --add-topic "machine-learning" `
        --add-topic "metallogenic-typing" `
        --add-topic "mineral-exploration" `
        --add-topic "la-icp-ms" `
        --add-topic "ore-deposits" `
        --add-topic "smote" `
        --add-topic "logo-cv" `
        --add-topic "explainable-ai"

    if ($LASTEXITCODE -eq 0) {
        Ok "GitHub About metadata and topics updated."
    } else {
        Warn "GitHub About update failed. You can still update manually from the repo About gear icon."
    }
}

function Update-ProfileReadme([string]$Owner, [string]$PathForProfileRepo, [bool]$DoPush) {
    Info "Updating GitHub profile README repository: $Owner/$Owner"

    if (-not (Test-Path $PathForProfileRepo)) {
        git clone "https://github.com/$Owner/$Owner.git" $PathForProfileRepo
    }

    Push-Location $PathForProfileRepo
    try {
        git pull
        $profileReadmePath = Join-Path $PathForProfileRepo "README.md"

        $section = @"
<!-- PYRITE_AI_REPO_START -->

## Featured Research Repository

### Artificial Intelligence-Driven Metallogenic Typing of Pyrite

**Repository:** https://github.com/$Owner/Pyrite-AI-metallogenic-typing

This repository supports the _Journal of Geochemical Exploration_ paper on AI-driven metallogenic typing of pyrite from global ore systems. It includes reproducible notebooks for preprocessing, class balancing, supervised machine-learning classification, model evaluation, t-SNE visualization, feature-importance analysis, and web-app deployment.

**Scientific focus:** pyrite trace-element geochemistry, LA-ICP-MS, metallogenic discrimination, class imbalance, SMOTE/RUC-style resampling, LOGO cross-validation, and interpretable machine learning.

**Models:** Random Forest, Support Vector Machine, Gradient Boosting, and Multilayer Perceptron.

**Paper:** Gul et al. (2026), _Journal of Geochemical Exploration_, 289, 108138.  
https://doi.org/10.1016/j.gexplo.2026.108138

<!-- PYRITE_AI_REPO_END -->
"@

        if (Test-Path $profileReadmePath) {
            $text = Get-Content $profileReadmePath -Raw
            $pattern = '(?ms)<!-- PYRITE_AI_REPO_START -->.*?<!-- PYRITE_AI_REPO_END -->'
            if ([regex]::IsMatch($text, $pattern)) {
                $text = [regex]::Replace($text, $pattern, $section)
            } else {
                $text = $text.TrimEnd() + "`r`n`r`n" + $section + "`r`n"
            }
        } else {
            $text = "# $Owner`r`n`r`n" + $section + "`r`n"
        }

        Set-Content -Path $profileReadmePath -Value $text -Encoding UTF8 -NoNewline
        git add README.md
        git diff --cached --quiet
        if ($LASTEXITCODE -eq 0) {
            Ok "Profile README already up to date."
        } else {
            git commit -m "Add featured pyrite AI metallogenic typing repository"
            if ($DoPush) {
                git push
                Ok "Profile README pushed."
            } else {
                Warn "Push disabled for profile README."
            }
        }
    } finally {
        Pop-Location
    }
}

function Attempt-PinRepositories([string]$Owner) {
    if (-not (HasCommand "gh")) {
        Warn "GitHub CLI not found. Skipping profile pin attempt."
        return
    }

    Warn "Attempting profile pins through GraphQL. This may fail if your GitHub token lacks required permissions or if GitHub changes the profile-pin schema."

    $pinnedRepos = @(
        "Pyrite-AI-metallogenic-typing",
        "Galena-Geochemistry-ML-Metallogenic-Discrimination",
        "Sphalerite-Gunga-Pb-Zn-DeepLearning",
        "Pyrite-Gunga-Pb-Zn-Deposit--Machine-Learning",
        "Dr-Amar.github.io"
    )

    try {
        $userId = gh api graphql -f query='query { viewer { id login } }' --jq ".data.viewer.id"
        if ([string]::IsNullOrWhiteSpace($userId)) {
            Warn "Could not read viewer ID. Skipping profile pins."
            return
        }

        $ids = @()
        foreach ($r in $pinnedRepos) {
            $id = gh api graphql -F owner=$Owner -F name=$r -f query='query($owner:String!, $name:String!){ repository(owner:$owner, name:$name){ id } }' --jq ".data.repository.id" 2>$null
            if (-not [string]::IsNullOrWhiteSpace($id)) { $ids += $id }
        }

        if ($ids.Count -eq 0) {
            Warn "No repository IDs found for pinning."
            return
        }

        $fields = @("graphql", "-f", "query=mutation(`$userId:ID!, `$ids:[ID!]!){ updateUserPinnedRepositories(input:{userId:`$userId, pinnableItemIds:`$ids}){ user{ login } } }", "-F", "userId=$userId")
        foreach ($id in $ids) {
            $fields += "-F"
            $fields += "ids[]=$id"
        }

        & gh api @fields
        if ($LASTEXITCODE -eq 0) {
            Ok "Profile pins updated."
        } else {
            Warn "Profile pin attempt failed. Profile README and repo metadata were still automated."
        }
    } catch {
        Warn "Profile pin attempt failed: $($_.Exception.Message)"
    }
}

# Main
Info "Starting pyrite GitHub automation"

if (-not (HasCommand "git")) {
    Fail "Git is not installed or not available in PATH."
}

if (-not (Test-Path $RepoRoot)) {
    Fail "RepoRoot not found: $RepoRoot"
}

Ensure-GitIdentity

Push-Location $RepoRoot
try {
    Info "Working in: $RepoRoot"

    if (-not (Test-Path ".git")) {
        git init
        Ok "Initialized Git repository."
    }

    Ensure-Remote -Owner $GithubOwner -Name $RepoName

    # Make figure folder
    New-Item -ItemType Directory -Force -Path "reports\figures" | Out-Null

    # Copy Graphical Abstract if present
    if (Test-Path ".\GA.jpg") {
        Copy-Item ".\GA.jpg" ".\reports\figures\graphical_abstract.jpg" -Force
        Ok "Copied GA.jpg to reports/figures/graphical_abstract.jpg"
    } elseif (Test-Path ".\reports\figures\graphical_abstract.jpg") {
        Ok "Graphical abstract already present."
    } else {
        Warn "GA.jpg not found. README will reference reports/figures/graphical_abstract.jpg; add the image if missing."
    }

    # Copy Methods workflow if present
    if (Test-Path ".\Methods.png") {
        Copy-Item ".\Methods.png" ".\reports\figures\methods_workflow.png" -Force
        Ok "Copied Methods.png to reports/figures/methods_workflow.png"
    } elseif (Test-Path ".\reports\figures\methods_workflow.png") {
        Ok "Methods workflow already present."
    } else {
        Warn "Methods.png not found. README will reference reports/figures/methods_workflow.png; add the image if missing."
    }

    # Ensure model heatmap figure still present if it exists
    if (-not (Test-Path ".\reports\figures\model_performance_heatmaps_4panel.png")) {
        Warn "model_performance_heatmaps_4panel.png not found. README will still reference it; add it if needed."
    }

    Write-EnhancedReadme -ReadmePath ".\README.md"

    Invoke-GitCommitIfNeeded -Message $CommitMessage -DoPush $Push
} finally {
    Pop-Location
}

if ($UpdateRepoAbout) {
    Update-RepoAbout -Owner $GithubOwner -Name $RepoName
}

if ($UpdateProfileReadme) {
    Update-ProfileReadme -Owner $GithubOwner -PathForProfileRepo $ProfileRepoPath -DoPush $Push
}

if ($AttemptProfilePins) {
    Attempt-PinRepositories -Owner $GithubOwner
} else {
    Info "Profile pinning skipped by default. To attempt it, rerun with: -AttemptProfilePins `$true"
}

Ok "Automation complete."
Write-Host ""
Write-Host "Refresh: https://github.com/$GithubOwner/$RepoName" -ForegroundColor Green
Write-Host "Profile: https://github.com/$GithubOwner" -ForegroundColor Green
