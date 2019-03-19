#Construct the given test set
test_set <- read.csv("Test_set.csv")
test_set$order <- c(1:nrow(test_set))
str(test_set)

library(dplyr)
test_fnr <- select(test_set, c(extraction_type,
                               management,
                               payment,
                               water_quality,
                               quantity,
                               source,
                               waterpoint_type))

#re-order the factor of extraction_type
test_fnr$extraction_type <- factor(test_fnr$extraction_type,
                                   levels = c(levels(test_fnr$extraction_type),"other - mkulima/shinyanga"))


test_fnr$extraction_type <- factor(test_fnr$extraction_type,
                                   levels(test_fnr$extraction_type)[c(1:10,18,11:17)])



#prediction fnr
for (i in 1: (nrow(a))) {
  test_fnr$temple <- test_fnr[,a[i,1]]
  test_fnr$temple <- ifelse(test_fnr[,a[i,1]] == levels(test_fnr[,a[i,1]])[a[i,2]],1,0)
  colnames(test_fnr)[names(test_fnr) == "temple"]  <- paste0(colnames(test_fnr)[a[i,1]],"_",levels(test_fnr[,a[i,1]])[a[i,2]])
}
test_fnr[,1:7] <- NULL

prob_pred = predict(classifier, type = "response", newdata = test_fnr)
y_pred = ifelse(prob_pred > 0.7, 1, 0)
length(which(y_pred == 1))

Submission <- read.csv("SubmissionFormat.csv")
Submission$order <- seq(1:nrow(Submission))
Submission$status_group <- y_pred
Submission$status_group <- as.factor(Submission$status_group)

test_set$result_fnr <- y_pred

write.csv(test_set, "test_mine")  
write.csv(Submission, "submission_mine.csv")

#prediction fnf
test_set <- read.csv("test_mine")
test_fnf <- filter(test_set,result_fnr == 0)

test_fnf$extraction_type <- factor(test_fnf$extraction_type,
                                   levels = c(levels(test_fnf$extraction_type),"other - mkulima/shinyanga"))


test_fnf$extraction_type <- factor(test_fnf$extraction_type,
                                   levels(test_fnf$extraction_type)[c(1:10,18,11:17)])


test_fnf <- select(test_fnf, c(construction_year,
                               extraction_type,
                               management,
                               payment,
                               water_quality,
                               quantity,
                               source,
                               waterpoint_type))

test_fnf$construction_year <- as.factor(test_fnf$construction_year)
for (j in 1:ncol(test_fnf)) {
  for (i in 1: length(levels(test_fnf[,j]))) {
    test_fnf$temple <- test_fnf[,j]
    test_fnf$temple <- ifelse(test_fnf[,j] == levels(test_fnf[,j])[i],1,0)
    colnames(test_fnf)[names(test_fnf) == "temple"]  <- paste0("vector", j,"_",i) 
  }
}

for (j in 1:nrow(u)) {
  test_fnf[,which(colnames(test_fnf) == paste0("vector", u[j,1],"_",u[j,2]))] <- NULL
  
}
test_fnf[1:8] <- NULL
test_fnf[,1] <- NULL

y_pred = predict(classifier, newdata = test_fnf)


Submission <- read.csv("submission_mine.csv")
submission_fnf <- filter(Submission, status_group == 0)
submission_fnf$status_group <- y_pred
submission_fnf$status_group <- factor(submission_fnf$status_group,
                                      levels = c(1,0),
                                      labels = c(2,3))

write.csv(test_fnf, "test_fnf.csv")
submission_fnr <- filter(Submission, status_group == 1)
submission_result <- rbind(submission_fnr,submission_fnf)
submission_result <- arrange(submission_result,desc(-submission_result$X))
submission_result$status_group <- factor(submission_result$status_group,
                                         levels = c(1,2,3),
                                         labels = c("functional needs repair","functional","non functional"))
summary(submission_result$status_group)

