## Test environments

* local macOS (aarch64-apple-darwin23), R 4.6.1
* GitHub Actions: ubuntu-latest (R devel, release, oldrel-1)
* GitHub Actions: macos-latest (R release)
* GitHub Actions: windows-latest (R release)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

We checked 26 reverse dependencies (24 from CRAN + 2 from Bioconductor), comparing R CMD check results across CRAN and dev versions of this package.

* We saw 0 new problems
* We failed to check 2 Bioconductor packages, neither because of bibtex:
  * ChemmineR: its suggested package ChemmineDrugs depends on ChemmineR, so it could not be installed; a manual R CMD check gave identical results with both versions.
  * scRNAseqApp: timed out building vignettes with both versions, as for the 0.5.2 submission.

## Changes in this version

* `read.bib()` takes the year from BibLaTeX dates instead of failing, uses `journaltitle` as `journal`, and reads files with brace-less `@Comment` lines or trailing `%` comments, and empty files (#15, #56, #57, #64).
* R >= 3.6.0 is now required, which the parser already needed, and the backports dependency is dropped.
