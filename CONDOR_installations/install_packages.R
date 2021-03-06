
repo <- "http://cran.us.r-project.org"


source("http://bioconductor.org/biocLite.R")
biocLite(ask = FALSE)
biocLite(c("AnnotationDbi", "impute", "GO.db", "preprocessCore"), ask = FALSE) 
biocLite("org.Mm.eg.db")
biocLite("BiocGenerics")
biocLite("S4Vectors")


install.packages("parallel", repos = repo)
install.packages("stats4", repos = repo)

install.packages("plyr", repos = repo)
install.packages("dplyr", repos = repo)
install.packages("tidyr", repos = repo)
install.packages("stringr", repos = repo)
install.packages("magrittr", repos = repo)
install.packages("reshape2", repos = repo)
install.packages("data.table", repos = repo)

install.packages("optparse", repos = repo)
install.packages("WGCNA", repos = repo)
install.packages("flashClust", repos = repo)

