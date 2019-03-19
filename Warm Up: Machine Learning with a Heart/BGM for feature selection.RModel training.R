#Model training
#Feature selection
train_set_new <- train_set
train_set_new$fasting_blood_sugar_gt_120_mg_per_dl <-NULL
train_set_new$resting_ekg_results <- NULL
train_set_new$serum_cholesterol_mg_per_dl <- NULL
train_set_new$thal_fixed <- NULL
train_set_new$slope_1 <-NULL
train_set_new$slope_2 <-NULL
train_set_new$oldpeak_eq_st_depression <- NULL
train_set_new$exercise_induced_angina <- NULL
train_set_new$age <- NULL

#Build train and test set
library(caTools)
split = sample.split(train_set_new, SplitRatio = 0.75)
training_set = subset(train_set_new, split == TRUE)
testing_set = subset(train_set_new, split == FALSE)

#logistic regression
classifier = glm(formula = result ~ ., 
                 family = binomial,
                 data = training_set)

#Predicting the Test set results
prob_pred = predict(classifier, type = "response", newdata = testing_set[,-11])
y_pred = ifelse(prob_pred > 0.5, 1, 0)

#Making the confusion Matrix
cm = table(testing_set[,11], y_pred)
cm
