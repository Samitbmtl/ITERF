iterf.news <- function(...) {
  newsfile <- file.path(system.file(package="ITERF"), "NEWS")
  file.show(newsfile)
}
