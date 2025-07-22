.onAttach <- function(libname, pkgname) {
  iterf.version <- read.dcf(file=system.file("DESCRIPTION", package=pkgname), 
                            fields="Version")
  packageStartupMessage(paste("\n",
                              pkgname,
                              iterf.version,
                              "\n",
                              "\n",
                              "Type iterf.news() to see new features, changes, and bug fixes.",
                              "\n",
                              "\n"))
}
