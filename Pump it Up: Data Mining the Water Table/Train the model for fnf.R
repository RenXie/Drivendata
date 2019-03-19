#Data normalization
dataset_fnf0 <- filter(dataset_fnf, dataset_fnf$result_fnf == 0)
dataset_fnf1 <- filter(dataset_fnf, dataset_fnf$result_fnf == 1)



set.seed(123)
random_fnf0 <- sample(1:nrow(dataset_fnf0), 10000)
random_fnf1 <- sample(1:nrow(dataset_fnf1), 10000)
# train_set_fnf <- rbind(dataset_fnf0[random_fnf0,], dataset_fnf1[random_fnf1,])

train_set_fnf <- rbind(dataset_fnf0[random_fnf0,], dataset_fnf1[random_fnf1,])


#delet repeated column
# train_set <- dataset
train_set_fnf[,1:which(colnames(train_set_fnf) == "result")] <- NULL

#split
library(caTools)
split = sample.split(train_set_fnf, SplitRatio = 0.8)
training_set_fnf = subset(train_set_fnf, split == TRUE)
testing_set_fnf = subset(train_set_fnf, split == FALSE)

#Random forest
library(randomForest)
classifier_fnf = randomForest(x = training_set_fnf[,-which(colnames(training_set_fnf) == "result_fnf")],
                          y = training_set_fnf$result_fnf,
                          ntree = 300)



# Predicting the Test set results
y_pred = predict(classifier_fnf, newdata = testing_set_fnf[,-which(colnames(testing_set_fnf) == "result_fnf")])

# Making the Confusion Matrix
cm = table(testing_set_fnf[, which(colnames(testing_set_fnf) == "result_fnf")], y_pred)
cm
sum(cm[1,1] + cm[2,2])/ sum(cm)