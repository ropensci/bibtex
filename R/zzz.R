.onLoad <- function(libname, pkgname) {
  backports::import(pkgname, "trimws")
  invisible()
}
