#Submission
Submission <- read.csv('submission_format.csv')
Submission$heart_disease_present <- Prediction
write.csv(Submission, 'Submission.csv')
