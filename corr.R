
# Write a function that takes a directory of data files and a threshold for complete cases and calculates the correlation between sulfate and nitrate for monitor locations where the number of completely observed cases (on all variables) is greater than the threshold. The function should return a vector of correlations for the monitors that meet the threshold requirement. If no monitors meet the threshold requirement, then the function should return a numeric vector of length 0. A prototype of this function follows

corr <- function(directory, threshold = 0) {
  com_res0 <- com_res$id[as.numeric(as.character(com_res$nobs)) > threshold]
  ok_ids <- as.numeric(as.character(com_res0))
  selected_sulfate_list <- lapply(ok_ids, function(x){dat$sulfate[dat$ID == x & !is.na(dat$sulfate) & !is.na(dat$nitrate)]}) 
  # head(str(selected_sulfate_list))
  # List of 31
  # $ : num [1:3652] NA NA NA NA NA NA NA NA NA NA ...
  # $ : num [1:4018] NA NA NA NA NA NA NA NA NA NA ...
  
  selected_nitrate_list <- lapply(ok_ids, function(x){dat$nitrate[dat$ID == x & !is.na(dat$sulfate) & !is.na(dat$nitrate)]})

  len <- length(selected_sulfate_list)
  all_cors <- vector("numeric", length = length(len))
  
  for (i in 1:len) {
    mt_sulf <- selected_sulfate_list[[i]]
    mt_nitr <- selected_nitrate_list[[i]]
    
    all_cors[[i]] <- cor(mt_sulf, mt_nitr)
  }
  all_cors
}
