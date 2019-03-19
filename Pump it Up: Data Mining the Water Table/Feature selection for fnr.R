#Select the feature of "functional need repair" (fnr)
library(dplyr)
dataset_ny <- select(dat, c(extraction_type,
                           management,
                           payment,
                           water_quality,
                           quantity,
                           source,
                           waterpoint_type))


dataset_ny$result <- read.csv("Training_Result.csv")[,2]

dataset_fnr <- filter(dataset_ny, result == "functional needs repair")






#Calculation the percentage of fnf result in each factors
p <- matrix(1,nrow = (ncol(dataset_fnr)-1), ncol = 60) 
for (m in 1:(ncol(dataset_fnr)-1)) {
  for (l in 1:length(levels(dataset_fnr[,m]))) {
    p[m,l] <- length(which(dataset_fnr[,m] == levels(dataset_fnr[,m])[l]))/length(which(dataset_p[,m] == levels(dataset_p[,m])[l]))
  }
}

#factor selected for training the model
a <- which(p <= 0.09 & p >= 0.03, arr.ind = TRUE)
a <- a[order(a[,1]),]

b <- matrix(nrow = nrow(a), ncol = 2)
for (i in 1: nrow(a)) {
  b[i,1] <- colnames(dataset_fnr)[a[i,1]]  
  b[i,2] <- levels(dataset_fnr[,a[i,1]])[a[i,2]]
}
if (isTRUE(which(b[,2] == "unknown")) == TRUE){
  a <- a[-which(b[,2] == "unknown"),]
  # a <- a[-which(b[,2] == 0),]
}





summary(dataset_fnr$result)