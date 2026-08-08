---
name: drive-organizer
description: Use when organizing recently downloaded files into Google Drive, to move files from ~/Downloads to gdrive: (mounted at ~/gdrive)
---

# Drive Organizer

Organizes files in `~/Downloads` (modified in last 1 hour) by moving them to the correct location in Google Drive (`gdrive:` remote, mounted at `~/gdrive`). Maintains a self-updating pattern registry; uses AI-assisted drive scanning for unknown files.

## Setup (run once)

Invoke the `update-config` skill to create `~/Downloads/.claude/settings.json` with the project-level allowlist, or verify it already exists:

```bash
cat ~/Downloads/.claude/settings.json
```

## Workflow

### Step 1: Check mount state

```bash
mountpoint -q ~/gdrive && echo "MOUNTED" || echo "NOT_MOUNTED"
```

- **MOUNTED** → note `WAS_MOUNTED=true`. Do NOT mount or unmount.
- **NOT_MOUNTED** → run:
  ```bash
  rclone mount gdrive: ~/gdrive --daemon
  ```
  Note `WAS_MOUNTED=false`. If this fails → abort and tell user: "Check rclone config with `rclone config`."

### Step 2: Find recent files

```bash
find ~/Downloads -maxdepth 1 -type f -mmin -60
```

If no files found → tell user "No files modified in the last hour in ~/Downloads." Then go to Step 8 (unmount if needed).

### Step 3: Match against Known Patterns

For each file, check its basename against every regex in the **Known Patterns** table using Python-compatible `re.search`.

Use this pattern to test each file:
```bash
python3 /home/aloysio/.claude/skills/drive-organizer/match_pattern.py 'REGEX' 'BASENAME'
```
Replace REGEX with the table entry (treating \| as |) and BASENAME with the file's basename.

- **Matched files** → add to auto-queue. Show user before moving:
  ```
  Auto-matched (will move automatically):
    1. sfr-facture-123456.pdf → /home/aloysio/gdrive/pessoal/financeiro/franca/internet/2025
  ```
- **Unmatched files** → show numbered list:
  ```
  Unmatched files (select which to handle):
    1. report.docx
    2. photo.jpg
  Enter numbers separated by spaces (e.g. "1 2"), or "none" to skip:
  ```
  If user types "none" → skip Steps 4–7, go to Step 8.

### Step 4: Drive scan + content parsing for selected unmatched files

```bash
find ~/gdrive -maxdepth 3 -type d | sort
```

For PDF or document files, extract text content before guessing a destination:

```bash
pdftotext "<file>" - 2>/dev/null | head -80
```

If `pdftotext` returns nothing useful (scanned image PDF, encrypted, etc.), read the file with the Read tool as a fallback.

Use the extracted content — issuer name, amounts, dates, addresses — combined with the **Drive Conventions** section and existing folder structure to suggest the single best destination.

> **Priority:** Prefer a folder already visible in the `find` output. Fall back to type heuristics only if no plausible match exists. If suggesting a new path not in the scan, state it explicitly in the confirmation table as "(new folder)".

### Step 5: Confirm moves

Show a confirmation table for ALL files (auto-matched + user-selected unmatched):

```
| # | File                      | Destination                                              | New name     |
|---|---------------------------|----------------------------------------------------------|--------------|
| 1 | sfr-facture-123456.pdf    | /home/aloysio/gdrive/pessoal/financeiro/franca/internet/2025 | (keep)   |
| 2 | report.docx               | /home/aloysio/gdrive/pessoal/trabalho/reports            | (keep)       |
```

User options:
- Type `ok` to accept all
- Type a row number to edit that row's destination or new name
- If a destination folder doesn't exist → ask "Folder `/path/to/folder` doesn't exist. Create it? (y/n)" before proceeding

### Step 6: Execute moves

For each confirmed move:

1. If folder doesn't exist and user approved:
   ```bash
   mkdir -p ~/gdrive/<destination_folder>
   ```
2. ALWAYS check for conflict before moving:
   ```bash
   test -e ~/gdrive/<destination>/<filename> && echo "EXISTS" || echo "OK"
   ```
   - `EXISTS` → warn "File already exists at destination, skipping." Do not overwrite.
   - `OK` → move:
     ```bash
     mv ~/Downloads/<filename> ~/gdrive/<destination_folder>/<new_name_or_original>
     ```

### Step 7: Update Known Patterns

For each file that was NOT already matched by a pattern and was successfully moved:

1. Propose a regex based on the filename. Examples:
   - `report_2025-05-09.docx` → propose `report_\d{4}-\d{2}-\d{2}\.docx`
   - `holiday_photo_001.jpg` → flag as likely one-off, ask user whether to add a pattern
2. ALWAYS show: `Add pattern \`<regex>\` → \`<destination>\` to Known Patterns? (y/edit/n)` — never append silently.
3. On `y` or `edit` → append a new row to the **Known Patterns** table below in this file.

### Step 7b: Update Drive Conventions

After all moves, review if any new structural pattern was observed (new subfolder convention, new address folder, new naming style). If so, update the **Drive Conventions** section in this skill file before proceeding.

### Step 8: Unmount

ONLY execute this step if `WAS_MOUNTED=false`. If you are unsure, go back to Step 1 and check now.

```bash
fusermount3 -u ~/gdrive
```

If that fails (e.g. `fusermount3` not found):

```bash
umount ~/gdrive
```

Note: `fusermount` (without `3`) is not available on this system. `rclone unmount` is also not a valid rclone command.

**Note on regex syntax:** In this Markdown table `\|` represents regex alternation `|`. When matching, treat every `\|` as `|` in `re.search`.

**Note on year-locked paths:** Destinations containing a year (e.g. `/2026/`) must be updated at the start of each new year. Before moving a file, check that the year in the destination matches the current year (`date +%Y`). If it doesn't, update the row in this table first.

## Known Patterns

| Regex | Destination | Notes |
|-------|-------------|-------|
| `COMPTEDEDEPOT_08941248671_\d{8}\.pdf` | `/home/aloysio/gdrive/pessoal/financeiro/bancos/lcl/documents/input` | LCL bank statement |
| `COMPTEDEDEPOTS_08941248639_\d{8}\.pdf` | `/home/aloysio/gdrive/pessoal/financeiro/bancos/lcl/documents/input` | LCL savings statement |
| `\d{4}_\d{2}_BP_(janvier\|fevrier\|mars\|avril\|mai\|juin\|juillet\|aout\|septembre\|octobre\|novembre\|decembre)` | `/home/aloysio/gdrive/pessoal/financeiro/rendimentos/2026/x` | Pay slips |
| `sfr-facture-\d{6}\.pdf` | `/home/aloysio/gdrive/pessoal/financeiro/franca/internet/2026` | SFR internet/box invoices (renamed to YYYYMM format) |
| `sfr-facture-\d{10}-\d+-\d+\.pdf` | `/home/aloysio/gdrive/pessoal/financeiro/franca/mobile/2026` | SFR RED mobile invoices (rename to YYYYMM_sfr_red.pdf) |
| `GuiaDAS_80_KERNEL LABS LTDA_\d{6}\.pdf` | `/home/aloysio/gdrive/pessoal/financeiro/pj/contabilidade` | KERNEL LABS DAS (Simples Nacional tax guide) |
| `80.{0,3}GuiaPagamento_\d{14}_\d{6}_\d+\.pdf` | `/home/aloysio/gdrive/pessoal/financeiro/pj/contabilidade` | KERNEL LABS DARF payment guide (CNPJ is 14 digits; name may use `80 - ` or `80-`) |
| `80.{0,3}Recibo de Pagamento` | `/home/aloysio/gdrive/pessoal/financeiro/pj/contabilidade` | KERNEL LABS pay slip (rename to `80-Recibo de Pagamento_MMYYYY.pdf`) |
| `LIVRETEPARGNEPOPULAIRE_\d{11}_\d{8}\.pdf` | `/home/aloysio/gdrive/pessoal/financeiro/bancos/lcl/documents/account_savings_livret_ep` | LCL Livret Épargne Populaire statement |
| `LIVRETEPARGNEPOPULAIRE_\d{11}_\d{8}[- ]\(?\d\)?\.pdf` | `/home/aloysio/gdrive/pessoal/financeiro/bancos/lcl/documents/account_savings_livret_ep` | LCL LEP second file from a same-day download collision. The `-N` suffix is a browser artifact with **no** meaning — open the PDF and read line 3: `RECAPITULATIF N° x` → rename to `LIVRETEPARGNEPOPULAIRE_<acct>_<YYYYMMDD>-recapitulatif.pdf`; plain `N° x` → it is the monthly relevé, strip the suffix. |
| `Nubank_Extrato_de_Fundos_\d{4}-\d{2}\.pdf` | `/home/aloysio/gdrive/pessoal/financeiro/rendimentos/2027/imposto/brasil` | Nubank investment fund extract (destination year = income year + 1; update manually each year) |
| `Nubank_Extrato_de_taxas_e_tarifas_de_Fundos_[A-Z]+_[A-Z]+_[A-Z]+-\d{4}\.pdf` | `/home/aloysio/gdrive/pessoal/financeiro/rendimentos/2027/imposto/brasil` | Nubank quarterly fund fees/tariffs statement (destination year = income year + 1; update manually each year) |
| `\d{13}-\d{13}-detailed-invoice\.pdf` | `/home/aloysio/gdrive/pessoal/documentos/alojamento/840_cardeal_arcoverde/facturation/2026` | QuintoAndar monthly rent invoice (840 Cardeal Arcoverde). Filename IDs are not dates — open PDF to get the month, rename to `quinto_andar_fatura_YYYY_MM.pdf`. Year-locked path. |
| `\d+C\d+_\d+_\d+_\d{4}_\d{2}-BOLETO\.pdf` | `/home/aloysio/gdrive/pessoal/documentos/alojamento/840_cardeal_arcoverde/facturation/2026` | QuintoAndar monthly rent boleto (840 Cardeal Arcoverde). Date `YYYY_MM` is in the filename — rename to `quinto_andar_boleto_YYYY_MM.pdf`. Year-locked path. |

## Drive Conventions

Observed from scanning the drive. Update this section at the end of each session if new patterns are found.

### Naming
- **Folders**: `snake_case` (e.g. `840_cardeal_arcoverde`, `103_avenue_de_paris`, `etat_des_lieux`)
- **Files**: `snake_case` when renaming; preserve original name if not renaming
- **Dates in filenames**: `YYYY_MM` or `YYYY_MM_DD` (e.g. `quinto_andar_fatura_2026_05.pdf`)
- **Exception**: Legacy areas (`ita/`, old `pessoal/financeiro/`, `pessoal/arquivo/`) use mixed casing — don't rename files there

### Top-level domains
| Folder | Purpose |
|--------|---------|
| `pessoal/` | Personal life (documents, finances, housing, health) |
| `lix/` | PhD thesis and research at LIX |
| `ita/` | ITA university years |
| `x/` | École Polytechnique (academic, paiements, naturalisation) |
| `photos/` | Photo archive by year |

### Housing (`pessoal/documentos/alojamento/`)
Each apartment gets a `snake_case` address folder (e.g. `840_cardeal_arcoverde`, `103_avenue_de_paris`).  
Standard subfolders: `assurance/<year>/`, `bail/`, `facturation/<year>/`, `etat_des_lieux/`, `dossier/`, `garanties/`, `sinistres/`  
For Brazilian apartments: use `vistoria/` instead of `etat_des_lieux/` (Portuguese equivalent for move-in inspection photos/records)

### Finance (`pessoal/financeiro/`)
- `bancos/` — bank statements and documents by bank name
- `rendimentos/<year>/` — pay slips and income
- `franca/` — French utilities and bills
- `pagamentos/` — one-off payment receipts
- `compras/<YYYYMM>_<item>/` — purchase records
- `recibos/<year>/` — service receipts and software invoices by year

### Employment (`pessoal/empregos/<company>/`)
- One `snake_case` folder per employer (e.g. `enter`, `kili`, `lix`, `france_travail`)
- `onboarding/` — employment contracts, onboarding decks, benefit info
- `equity/` — share option grants, exercise notices, valuations, cap table letters
- DocuSign exports keep their original filename (names are unstable and carry no reliable date — identify by opening the PDF, not by filename)
- Known entity mapping: **Talisman AI Holdings Ltd / TALISMAN AI LTDA = Enter** (`getenter.ai`) → `empregos/enter/`

### Short-term rental (`pessoal/apartamentos/aluguel_temporada/`)
- `igms/faturas/<year>/` — iGMS/AirGMS annual subscription invoices
- `igms/relatorios/` — iGMS earnings and occupancy reports

### Brazilian rental leases (`pessoal/documentos/alojamento/<address>/bail/`)
- QuintoAndar contracts stored as: `QuintoAndar_-_Contrato_para_assinatura_(<contract_no>-1.pdf` (unsigned), `QuintoAndar_-_Contrato_assinado_(<property_code>).pdf` (signed), plus the original zip bundle

### Brazilian apartment utility bills (`pessoal/documentos/alojamento/<address>/facturation/<year>/`)
- All billing docs (rent + utilities) go together in `facturation/<year>/` — no separate subfolder for utilities
- Utility bills (Enel electricity, Comgás gas) renamed to `<provider>_<YYYY>_<MM>.pdf` (e.g. `enel_2026_06.pdf`, `comgas_2026_06.pdf`)
- Known address: `840_cardeal_arcoverde` = R. Cardeal Arcoverde 840 / R. João Moura 1119, Pinheiros, São Paulo (same apartment, two street references)

### Brazilian investment tax docs (`pessoal/financeiro/rendimentos/<year>/imposto/brasil/`)
- Folder year = **declaration year** (income year + 1). E.g. fund extracts for 2025 income → `rendimentos/2026/imposto/brasil/`
- Contains: Nubank fund extracts, B3 statements, acoes, proventos, saude, fgts, informes folders

### LCL Livret Épargne Populaire (`pessoal/financeiro/bancos/lcl/documents/account_savings_livret_ep/`)
- The folder holds **two different document types** under the same LCL filename pattern:
  - **Monthly relevé** — header reads `du DD.MM.YYYY au DD.MM.YYYY - N° x` (one-month span)
  - **Semi-annual recapitulatif** — header reads `... - RECAPITULATIF N° x` (six- or twelve-month span)
- LCL emits both on the same statement date, so the browser appends `-1` to whichever downloads second. **The suffix is arbitrary** — in the `20260130` pair the base name is the recapitulatif and `-1` the monthly; in the `20260731` pair it is the reverse. Never infer the type from the suffix; open the PDF.
- Going forward, disambiguate recapitulatifs with a `-recapitulatif` suffix and leave the monthly on the bare name. Pre-existing `-1` files are left as-is (legacy area, don't rename).

### Regenerated statements (supersede-in-place)
Some issuers (notably Nubank) re-emit a statement for the same period under an **identical filename** with fuller data. Same name + different md5 is therefore not always a duplicate. Compare the emission line (`Emitido em ...`) via `pdftotext`; if the incoming file is newer and more complete, archive the existing copy as `<name>_emitido_<YYYYMMDD>.pdf` (using the old file's emission date) and move the new one in under the canonical name. Never overwrite.

### Year folders
Financial and insurance docs use year subfolders (e.g. `/2026/`). Always verify the year matches `date +%Y` before moving.

## Edge Cases

| Situation | Action |
|-----------|--------|
| `rclone mount` fails | Abort. Tell user: "Run `rclone config` to check gdrive: remote." |
| Destination file already exists | Warn and skip that file. Do not overwrite. |
| User selects "none" from unmatched | Skip Steps 4–7. Go directly to Step 8. |
| Folder path doesn't exist | Ask user before `mkdir -p`. |
| Proposed regex is too broad | Flag it, let user edit before appending to Known Patterns. |
| No files found in last hour | Exit early. Still run Step 8 if WAS_MOUNTED=false. |
