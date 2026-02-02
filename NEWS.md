# bibtex 0.5.3

## Bug fixes

- Fixed `make.bib.entry()` failing on YYYY-MM date format without day by appending "-01" before parsing ([#56](https://github.com/ropensci/bibtex/issues/56)).
- Added BibLaTeX compatibility by mapping `journaltitle` to `journal` field ([#57](https://github.com/ropensci/bibtex/issues/57)).

# bibtex 0.5.2

## Bug fix

- Fixed `read.bib()` silently returning empty `bibentry()` when entries have trailing whitespace after closing brace ([#59](https://github.com/ropensci/bibtex/issues/59), [PR #60](https://github.com/ropensci/bibtex/pull/60)).

## Testing

- Added snapshot test variants for R-devel to handle `bibentry` formatting changes from `deparseLatex()` updates in R 4.6.0.

## Documentation

- Migrated `inst/NEWS.Rd` to `NEWS.md`.

# bibtex 0.5.1

## Bug fix

- Replaced `as.personList(authors)` with `do.call(c, authors)` as requested by CRAN ([PR #52](https://github.com/ropensci/bibtex/pull/52)).

# bibtex 0.5.0

## New Features

- The underlying parsing logic of bibtex files has been completely rewritten (huge thank you to [Diego Hernangómez (@dieghernan)](https://github.com/dieghernan), [PR #47](https://github.com/ropensci/bibtex/pull/47))

## Unit Tests

- Unit tests are now using testthat version 3 ([Diego Hernangómez (@dieghernan)](https://github.com/dieghernan), [PR #46](https://github.com/ropensci/bibtex/pull/46)).



# bibtex 0.4.3

## Bug fixes

- Applied CRAN stabilization patches. ([#31](https://github.com/ropensci/bibtex/pull/31), thanks Prof. Brian Ripley!)
- Removed dependency on `stringr`. ([#25](https://github.com/ropensci/bibtex/pull/25), thanks [@mllg](https://github.com/mllg))
- `ArrangeAuthors()` is now case insensitive when searching for and in an AND-joined list. ([#22](https://github.com/ropensci/bibtex/pull/22), thanks [@katrinleinweber](https://github.com/katrinleinweber))
- `findBibFile()` now looks at `inst/REFERENCES.bib` in addition to `REFERENCES.bib`.
  ([#19](https://github.com/ropensci/bibtex/pull/19), thanks [@ms609](https://github.com/ms609))

## Documentation

- Refreshed README content. ([#29](https://github.com/ropensci/bibtex/pull/29)).
- Updated Package Maintainer and contributors.
  ([#30](https://github.com/ropensci/bibtex/pull/30))

## Deployment

- Switched CI from TravisCI to GitHub Actions. ([#29](https://github.com/ropensci/bibtex/pull/29))
- Added a `pkgdown` site for the package. ([#29](https://github.com/ropensci/bibtex/pull/29))

# bibtex 0.4.0

- Removed the function `yy_fatal_error` which even though it was never actually called, triggered some R CMD check nuisance.
- Removed useless dependency on Rcpp which bibtex no longer uses.
- Added cite by key functionality to `read.bib` (pull request by Michael Koohafkan).

# bibtex 0.3-5

- Fix for bib files with no content.

# bibtex 0.3-1

- New function `write.bib` contributed by Renaud Gaujoux.
- Missing `%` in error reporting in `read.bib` (fix provided by Renaud Gaujoux).

# bibtex 0.3-0

- Fixed long standing bug re backslashes.
