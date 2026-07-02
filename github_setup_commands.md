# GitHub setup commands

Recommended repository name:

```text
pyrite-ai-metallogenic-typing
```

## Option A: create a private repo first

```bash
cd pyrite-ai-metallogenic-typing-public-safe
git init
git add .
git commit -m "Initial release: pyrite metallogenic typing ML workflow"

# If GitHub CLI is installed:
gh repo create pyrite-ai-metallogenic-typing --private --source=. --remote=origin --push
```

## Option B: connect to an existing empty GitHub repo

```bash
cd pyrite-ai-metallogenic-typing-public-safe
git init
git add .
git commit -m "Initial release: pyrite metallogenic typing ML workflow"
git branch -M main
git remote add origin https://github.com/USERNAME/pyrite-ai-metallogenic-typing.git
git push -u origin main
```

## Later, after data permissions are clear

```bash
git add data/README.md DATA_ACCESS.md
git commit -m "Document data access policy"
git push
```
