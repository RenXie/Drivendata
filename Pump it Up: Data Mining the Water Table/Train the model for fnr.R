#training the model for "functional need repair"(fnr)
#Isolate the fnr result
dataset_fnr <- dataset_ny
dataset_fnr$result_fnr <- dataset_fnr$result
dataset_fnr$result_fnr <- factor(dataset_fnr$result_fnr,
                                 levels = levels(dataset_fnr$result_fnr),
                                 labels = c(0,1,0))
summary(dataset_fnr$result_fnr)


#feature construction
for (i in 1: (nrow(a))) {
  dataset_fnr$temple <- dataset_fnr[,a[i,1]]
  dataset_fnr$temple <- ifelse(dataset_fnr[,a[i,1]] == levels(dataset_fnr[,a[i,1]])[a[i,2]],1,0)
  colnames(dataset_fnr)[names(dataset_fnr) == "temple"]  <- paste0(colnames(dataset_fnr)[a[i,1]],"_",levels(dataset_fnr[,a[i,1]])[a[i,2]])
}


#Filther the dataset
dataset_fnr0 <- filter(dataset_fnr, dataset_fnr$result_fnr == 0)
dataset_fnr1 <- filter(dataset_fnr, dataset_fnr$result_fnr == 1)


# construction the train set
set.seed(123)
random_fnr0 <- sample(1:nrow(dataset_fnr0), 4000)
train_set_fnr <- rbind(dataset_fnr0[random_fnr0,], dataset_fnr1)


#delet repeated column
train_set_fnr[,1:which(colnames(train_set_fnr) == "result")] <- NULL

#logistic regression
classifier = glm(formula = result_fnr ~. , 
                 family = binomial,
                 data = training_set_fnr)

#Predicting the Test set results
prob_pred = predict(classifier, type = "response", newdata = testing_set_fnr[,-which(colnames(testing_set_fnr) == "result_fnr")])
y_pred = ifelse(prob_pred > 0.7, 1, 0)

#Making the confusion Matrix
cm = table(testing_set_fnr[,which(colnames(testing_set_fnr) == "result_fnr")], y_pred)
cm