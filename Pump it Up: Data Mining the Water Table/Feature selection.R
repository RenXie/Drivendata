dat <- read.csv("Training_set.csv")

summary(dat)

library(dplyr)
#select columns which relevant to the outcome
dataset <- select(dat, c(construction_year,
                         extraction_type,
                         extraction_type_group,
                         extraction_type_class,
                         management,
                         management_group,
                         payment,
                         payment_type,
                         water_quality,
                         quality_group,
                         quantity,
                         quantity_group,
                         source,
                         source_type,
                         source_class,
                         waterpoint_type,
                         waterpoint_type_group))

summary(dataset)
dataset$construction_year <- as.factor(dataset$construction_year)
str(dataset$construction_year)
str(dataset)
