
# Write a function that takes a directory of data files and a threshold for complete cases and calculates the correlation between sulfate and nitrate for monitor locations where the number of completely observed cases (on all variables) is greater than the threshold. The function should return a vector of correlations for the monitors that meet the threshold requirement. If no monitors meet the threshold requirement, then the function should return a numeric vector of length 0. A prototype of this function follows
com_result <- complete("specdata")

corr <- function(directory, threshold = 0) {
  files_full <- list.files(path = directory, pattern = "*.csv", full.names = T)
  tmp <- lapply(files_full, read.csv)
  dat <- do.call(rbind, tmp)
  
  com_res0 <- com_result$id[as.numeric(as.character(com_result$nobs)) > threshold]
  
  ok_ids <- as.numeric(as.character(com_res0))
  selected_sulfate_list <- lapply(ok_ids, function(x){dat$sulfate[dat$ID == x]}) 
  selected_nitrate_list <- lapply(ok_ids, function(x){dat$nitrate[dat$ID == x]})

  len <- length(selected_sulfate_list)
  all_cors <- vector("numeric", length = length(len))
  for (i in 1:len) {
    tryCatch(
      mt_sulf <- selected_sulfate_list[[i]],
      error = function(e){
        message("An error occurred in selected_sulfate_list[[i]]:\n", e)
      },
      #finally = mt_sulf <- numeric()
      return(numeric())
    )
    tryCatch(
      mt_nitr <- selected_nitrate_list[[i]],
      error = function(e){
        message("An error occurred in selected_nitrate_list[[i]]:\n", e)
      },
      return(numeric())
      #finally = mt_nitr <- numeric()
        #all_cors[[i]] < numeric()
    )
    
    
    
    all_cors[[i]] <- cor(mt_sulf, mt_nitr, use = "pairwise.complete.obs")
  }
  all_cors
}
# numeric()
