
# Write a function that takes a directory of data files and a threshold for complete cases and calculates the correlation between sulfate and nitrate for monitor locations where the number of completely observed cases (on all variables) is greater than the threshold. The function should return a vector of correlations for the monitors that meet the threshold requirement. If no monitors meet the threshold requirement, then the function should return a numeric vector of length 0. A prototype of this function follows

corr <- function(directory, threshold = 0) {
  # files_full <- list.files(path = directory, pattern = "*.csv", full.names = T)
  # tmp <- lapply(files_full, read.csv)
  # dat <- do.call(rbind, tmp)
  # com <- dat$ID[!is.na(dat$sulfate) & !is.na(dat$nitrate)]
  # com_res <- as.data.frame(table(com))
  # names(com_res) <- c("id", "nobs")
  com_res0 <- com_res$id[as.numeric(as.character(com_res$nobs)) > threshold]
  as.numeric(as.character(com_res0))
  
}