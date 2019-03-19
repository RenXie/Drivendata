#gbm
library(gbm)
#test run
gbm_fit <- gbm(formula = result ~.,
               distribution = 'bernoulli',
               data = training_set,
               n.trees = 5000,
               interaction.depth = 3,
               shrinkage = 0.1,
               cv.folds = 5)
gbm.perf(gbm_fit, method = 'cv')
min(gbm_fit$cv.error)

#Tunning the model
hyper_grid <- expand.grid(shrinkage = c(0.0001,0.0005, 0.001),
                          interaction.depth = c(1,3,5),
                          n.minobsinnode = c(5, 10, 15),
                          bag.fraction = c(0.65, 0.8, 1),
                          optimal_trees = 0,
                          min_RMSE = 0)
nrow(hyper_grid)

# randomize data
random_index <- sample(1:nrow(training_set), nrow(training_set))
random_ames_train <- training_set[random_index, ]

# grid search 
for(i in 1:nrow(hyper_grid)) {
  
  # train model
  gbm.tune <- gbm(
    formula = result ~.,
    distribution = 'bernoulli',
    data = random_ames_train,
    n.trees = 5000,
    interaction.depth = hyper_grid$interaction.depth[i],
    shrinkage = hyper_grid$shrinkage[i],
    n.minobsinnode = hyper_grid$n.minobsinnode[i],
    bag.fraction = hyper_grid$bag.fraction[i],
    train.fraction = .75,
    n.cores = NULL, # will use all cores by default
    verbose = FALSE
  )
  
# add min training error and trees to grid
  hyper_grid$optimal_trees[i] <- which.min(gbm.tune$valid.error)
  hyper_grid$min_RMSE[i] <- sqrt(min(gbm.tune$valid.error))
}


library(dplyr)
hyper_grid %>% 
  dplyr::arrange(min_RMSE) %>%
  head(10)



#Variable importance Visulisation
library(vip)
vip::vip(gbm_fit)
local_obs <- testing_set[1:2, -20]

#LIME : explaination of the predict value 
model_type.gbm <- function(x, ...) {
  return('regression')
}
predict_model.gbm <- function(x, newdata, ...){
  pred <- predict(x, newdata, ntree= x$n.trees)
  return(as.data.frame(pred))
}
explainer <- lime(training_set[-20], gbm_fit)
explanation <- explain(local_obs,explainer,n_features = 20)
plot_features(explanation)

#Prediction
pred <- predict(gbm.fit.final, n.trees = gbm.fit.final$n.trees, testing_set[,-20])
y_pred <- ifelse(pred > 0.25, 1,0)
cm = table(testing_set[, 20], y_pred)
cm
