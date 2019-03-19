 hyper_grid <- expand.grid(shrinkage = c(0.0005,0.001),
                          interaction.depth = c(5,7,10),
                          n.minobsinnode = c(8,13,15),
                          bag.fraction = c(0.65, 0.85),
                          optimal_trees = 0,
                          min_RMSE = 0)
nrow(hyper_grid)
random_index <- sample(1:nrow(training_set), nrow(training_set))
random_ames_train <- training_set[random_index, ]

set.seed(123)
# grid search 
for(i in 1:nrow(hyper_grid)) {
    
    # train model
    gbm.tune <- gbm(formula = result ~.,
                    distribution = 'bernoulli',
                    data = random_ames_train,
                    n.trees = 12000,
                    interaction.depth = hyper_grid$interaction.depth[i],
                    shrinkage = hyper_grid$shrinkage[i],
                    n.minobsinnode = hyper_grid$n.minobsinnode[i],
                    bag.fraction = hyper_grid$bag.fraction[i],
                    train.fraction = .75,
                    n.cores = NULL, # will use all cores by default
                    verbose = FALSE)
      
# add min training error and trees to grid
hyper_grid$optimal_trees[i] <- which.min(gbm.tune$valid.error)
hyper_grid$min_RMSE[i] <- sqrt(min(gbm.tune$valid.error))
}

hyper_grid %>% 
  dplyr::arrange(min_RMSE) %>%
  head(10)




set.seed(123)
gbm.fit.final <- gbm(
  formula = result ~ .,
  distribution = "bernoulli",
  data = training_set,
  n.trees = 9999,
  interaction.depth = 7,
  shrinkage = 0.0005,
  n.minobsinnode = 15,
  bag.fraction = .65, 
  train.fraction = 1,
  n.cores = NULL, # will use all cores by default
  verbose = FALSE
) 

gbm.perf(gbm.fit.final, method = 'cv')
min(gbm.fit.final$valid.error)
which.min(gbm.fit.final$valid.error)

par(mar = c(5, 8, 1, 1))
summary(
  gbm.fit.final, 
  cBars = 10,
  method = relative.influence, # also can use permutation.test.gbm
  las = 2
)

pred <- predict(gbm.fit.final, n.trees = gbm.fit.final$n.trees, testing_set[,-20])
y_pred <- ifelse(pred > 0.5, 1,0)
cm = table(testing_set[, 20], y_pred)
cm
