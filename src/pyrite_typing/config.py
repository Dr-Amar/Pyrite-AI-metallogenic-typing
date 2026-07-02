from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
DATA_PROCESSED = REPO_ROOT / "data" / "processed" / "Pyrite_Standarized_data_file_New_Paper.xlsx"
FEATURE_COLUMNS = ["Co", "Ni", "Cu", "Zn", "Se", "Ag", "Sb", "Pb", "Bi", "As"]
TARGET_COLUMN = "Deposit type"
RANDOM_SEED = 42
