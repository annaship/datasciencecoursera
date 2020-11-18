# Write a function that reads a directory full of files and reports the number of completely observed cases in each data file. The function should return a data frame where the first column is the name of the file and the second column is the number of complete cases.

is.decr <- function(v){all(diff(v) <= 0)}

complete <- function(directory, id = 1:332) {
  files_full <- list.files(path = directory, pattern = "*.csv", full.names = T)
  tmp <- lapply(files_full[id], read.csv)
  dat <- do.call(rbind, tmp)
  com <- dat$ID[!is.na(dat$sulfate) & !is.na(dat$nitrate)]
  com_res <- as.data.frame(table(factor(com, levels=unique(com))))
  names(com_res) <- c("id", "nobs")
  com_res
}
