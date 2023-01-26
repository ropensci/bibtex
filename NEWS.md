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
