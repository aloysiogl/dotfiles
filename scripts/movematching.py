import os
import re
import shutil


def move_file_to_folder(file_path: str, folder_path: str):
    new_file_path = os.path.join(folder_path, os.path.basename(file_path))
    if not os.path.exists(new_file_path):
        shutil.move(file_path, new_file_path)
        print(f"Moved: {file_path} -> {new_file_path}")
    else:
        print(f"File already exists: {new_file_path}")


def main():
    regexes_to_paths = {
        r"\d{4}_\d{2}_BP_(janvier|fevrier|mars|avril|mai|juin|juillet|aout|septembre|octobre|novembre|decembre)": "/home/aloysio/gdrive/pessoal/financeiro/rendimentos/2025/x",
        r"sfr-facture-\d{6}.pdf": "/home/aloysio/gdrive/pessoal/financeiro/franca/internet/2025",
    }
    folder_to_scan = os.path.expanduser("~/Downloads")
    file_list = [
        os.path.join(root, file)
        for root, _, files in os.walk(folder_to_scan)
        for file in files
    ]

    print(f"Scanning folder: {folder_to_scan}")
    moves: list[tuple[str, str]] = []
    for regex, folder_path in regexes_to_paths.items():
        for file in file_list:
            base_name = os.path.basename(file)
            if re.search(regex, base_name):
                moves.append((file, folder_path))

    if moves:
        for file, folder in moves:
            print(f"  {os.path.basename(file)} -> {folder}")

        response = input("\nDo you want to move these files? (y/n): ").strip().lower()
        if response == "y":
            for file, folder in moves:
                move_file_to_folder(file, folder)
            print(f"Moved {len(moves)} files.")
        else:
            print("Operation cancelled.")
    else:
        print("No matching files found.")


if __name__ == "__main__":
    main()
