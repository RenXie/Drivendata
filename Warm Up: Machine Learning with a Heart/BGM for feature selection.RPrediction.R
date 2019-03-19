#Predict the given test_set
#Feature selecion
test_set_new <- test_set
test_set_new$fasting_blood_sugar_gt_120_mg_per_dl <-NULL
test_set_new$resting_ekg_results <- NULL
test_set_new$serum_cholesterol_mg_per_dl <- NULL
test_set_new$thal_fixed <- NULL
test_set_new$slope_1 <-NULL
test_set_new$slope_2 <-NULL
test_set_new$oldpeak_eq_st_depression <- NULL
test_set_new$exercise_induced_angina <- NULL
test_set_new$age <- NULL

#Predicting the Test set results
Prediction = predict(classifier, type = "response", newdata = test_set_new)
