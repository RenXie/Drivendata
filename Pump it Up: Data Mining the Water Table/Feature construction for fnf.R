#Feature construction for "functional"  and "non functional"result (fnf)
dataset_fnf <- dat
dataset_fnf <- select(dat, c(construction_year,
                             extraction_type,
                             management,
                             payment,
                             water_quality,
                             quantity,
                             source,
                             waterpoint_type))

dataset_fnf$result <- read.csv("Training_Result.csv")[,2]
dataset_fnf$construction_year <- as.factor(dataset_fnf$construction_year)

#Isolate the fnf results
dataset_fnf<- filter(dataset_fnf, result != "functional needs repair")
dataset_fnf$result_fnf <- factor(dataset_fnf$result_fnf,
                                 levels = levels(dataset_fnf$result_fnf),
                                 labels = c(1,0,0))
#Break up the factors
for (j in 1:(ncol(dataset_fnf)-1)) {
  for (i in 1: length(levels(dataset_fnf[,j]))) {
    dataset_fnf$temple <- dataset_fnf[,j]
    dataset_fnf$temple <- ifelse(dataset_fnf[,j] == levels(dataset_fnf[,j])[i],1,0)
    colnames(dataset_fnf)[names(dataset_fnf) == "temple"]  <- paste0("vector", j,"_",i) 
  }
}

#Eliminate the factor which is "unkown"
for (j in 1:nrow(u)) {
  dataset_fnf[,which(colnames(dataset_fnf) == paste0("vector", u[j,1],"_",u[j,2]))] <- NULL
  
}
#Eliminate construction year = 0 (unknown)
dataset_fnf[,10] <- NULL