# ChemmineR ()

* : <UNKNOWN>

Run `revdepcheck::revdep_details(, "ChemmineR")` for more info

## Error before installation

### Devel

```
package ‘BiocGenerics’ successfully unpacked and SHA256 sums checked
package ‘knitr’ successfully unpacked and SHA256 sums checked
package ‘tinytex’ successfully unpacked and SHA256 sums checked
package ‘xfun’ successfully unpacked and SHA256 sums checked

The downloaded binary packages are in
	<tempdir>/downloaded_packages


trying URL 'https://cloud.r-project.org/bin/macosx/sonoma-arm64/contrib/4.6/xfun_0.61.tgz'
Content type 'application/x-gzip' length 661067 bytes (645 KB)
==================================================
downloaded 645 KB

installing the source package ‘ChemmineDrugs’

trying URL 'https://bioconductor.org/packages/3.23/data/annotation/src/contrib/ChemmineDrugs_1.0.2.tar.gz'
Content type 'application/x-gzip' length 45869833 bytes (43.7 MB)
==================================================
...

The downloaded source packages are in
	‘<tempdir>/downloaded_packages’
Error in (function (libdir, packages, quiet, repos)  : 
  all(packages %in% rownames(installed.packages(libdir[1]))) is not TRUE
In addition: Warning messages:
1: In utils::install.packages(pkgs = pkgs, lib = lib, repos = myrepos,  :
  installation of package ‘ChemmineDrugs’ had non-zero exit status
2: In utils::install.packages(pkgs = pkgs, lib = lib, repos = myrepos,  :
  installation of package ‘ChemmineDrugs’ had non-zero exit status


```
### CRAN

```
package ‘BiocGenerics’ successfully unpacked and SHA256 sums checked
package ‘knitr’ successfully unpacked and SHA256 sums checked
package ‘tinytex’ successfully unpacked and SHA256 sums checked
package ‘xfun’ successfully unpacked and SHA256 sums checked

The downloaded binary packages are in
	<tempdir>/downloaded_packages


trying URL 'https://cloud.r-project.org/bin/macosx/sonoma-arm64/contrib/4.6/xfun_0.61.tgz'
Content type 'application/x-gzip' length 661067 bytes (645 KB)
==================================================
downloaded 645 KB

installing the source package ‘ChemmineDrugs’

trying URL 'https://bioconductor.org/packages/3.23/data/annotation/src/contrib/ChemmineDrugs_1.0.2.tar.gz'
Content type 'application/x-gzip' length 45869833 bytes (43.7 MB)
==================================================
...

The downloaded source packages are in
	‘<tempdir>/downloaded_packages’
Error in (function (libdir, packages, quiet, repos)  : 
  all(packages %in% rownames(installed.packages(libdir[1]))) is not TRUE
In addition: Warning messages:
1: In utils::install.packages(pkgs = pkgs, lib = lib, repos = myrepos,  :
  installation of package ‘ChemmineDrugs’ had non-zero exit status
2: In utils::install.packages(pkgs = pkgs, lib = lib, repos = myrepos,  :
  installation of package ‘ChemmineDrugs’ had non-zero exit status


```
# scRNAseqApp (1.12.0)

* GitHub: <https://github.com/jianhong/scRNAseqApp>
* Email: <mailto:jou@morgridge.org>

Run `revdepcheck::revdep_details(, "scRNAseqApp")` for more info

## In both

*   R CMD check timed out


*   checking CRAN incoming feasibility ... NOTE
     ```
     Maintainer: ‘Jianhong Ou <jou@morgridge.org>’
     
     Unknown, possibly misspelled, fields in DESCRIPTION:
       ‘git_url’ ‘git_branch’ ‘git_last_commit’ ‘git_last_commit_date’
     
     The Title field should be in title case. Current version is:
       ‘A single-cell RNAseq Shiny app-package’
     In title case that is:
       ‘A Single-Cell RNAseq Shiny App-Package’
     
     This build time stamp is over a month old.
     ```

