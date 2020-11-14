# Write a function that reads a directory full of files and reports the number of completely observed cases in each data file. The function should return a data frame where the first column is the name of the file and the second column is the number of complete cases.

complete <- function(directory, id = 1:332) {
  files_full <- list.files(path = directory, pattern = "*.csv", full.names = T)
  tmp <- lapply(files_full[id], read.csv)
  dat <- do.call(rbind, tmp)
  # mean(dat[, pollutant], na.rm = TRUE)
  # length(!is.na(dat$sulfate) & !is.na(dat$nitrate))
  # subset(andy$Weight, andy$Day==30)
  # length(dat$ID[!is.na(dat$sulfate) & !is.na(dat$nitrate)])
  # (tmp$ID[!is.na(tmp$sulfate) & !is.na(tmp$nitrate)])
  # > for(f in tmp[1:2]) {
  #     print(head(f))
  #     f$ID[!is.na(f$sulfate) & !is.na(f$nitrate)]
  # }
  # t(as.data.frame(table(com))[,2]) 
  com <- dat$ID[!is.na(dat$sulfate) & !is.na(dat$nitrate)]
  as.data.frame(table(com), col.names = c("id", "nobs"))
  #names(com_res) <- c("id", "nobs")
  
  
}