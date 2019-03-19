#for predicting result

library(dplyr)
cap_set <- testing_set
cap_set$pred <- y_pred
cap_set <- arrange(cap_set,  desc(cap_set$pred))
m <- length(cap_set$result)
cap_pred <- NULL
for (i in 1:m) {
  cap_pred[i] = length(which(cap_set$result[1:(i)] == 1))
}
n <- length(which(cap_set$result == 1))
x_axis <- seq(0,m,1)
x_axis <- x_axis/m
pred_y <- c(0, cap_pred/n)

library(ggplot2)
ggplot() +  
  geom_abline(intercept = 0, slope = 1) +
  geom_line(aes(x= x_axis, y= pred_y ),
            colour = "blue") + 
  ylim(0.5,0.9)









