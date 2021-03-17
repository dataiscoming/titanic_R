#Function to produce a logit model

logit <- function(){
# model
res_logit <- glm(Survived ~ is_married + Family_size_2 + Age_5 + Fare_4 + Title_2 + Deck + Parch + SibSp + Pclass + Sex,
                 data = df_train, family = "binomial")

res_logit2 <- glm(Survived ~ is_married + Family_size_2 + Age_5,
                 data = df_train, family = "binomial")

#odds_ratio and 95% CI
exp(cbind(OR = coef(res_logit), confint(res_logit)))

# Summary
summary(res_logit)

# AIC : Akaike information criterion
AIC(res_logit)

# BIC : Bayesian information criterion
BIC(res_logit)

# Likelihood ratio test
# p-value for the overall model fit statistic that is less than 0.05 would compel us to reject the null hypothesis 
# H0 holds that the reduced model is true
lrtest(res_logit, res_logit2)

# Pseudo R2 - McFadden R2
pR2(res_logit)

# Wald chi-squared or F test
# if p-value are > 0.05, this suggests that removing the variable from the model will not substantially harm
# the fit of that model
wald.test(b = coef(res_logit), Sigma = vcov(res_logit), Terms = 1:10)

# Hosmer-Lemeshow Test
# Small values with large p-values indicate a good fit to the data while 
# large values with p-values below 0.05 indicate a poor fit
hoslem.test(res_logit$y, round(fitted(res_logit)), g=10)

# Confusion matrix
d_binomial <- tibble("target" = res_logit$y,
                     "prediction" = round(res_logit$fitted.values))
basic_table <- table(d_binomial)
cfm <- tidy(basic_table)
plot_confusion_matrix(cfm, 
                      target_col = "target", 
                      prediction_col = "prediction",
                      counts_col = "n",
                      add_sums = TRUE,
                      sums_settings = cvms::sum_tile_settings(
                        palette = "Oranges",
                        label = "Total",
                        tc_tile_border_color = "black"
                      ))

# Performance rate
accuracy_train <- (sum(diag(basic_table)))/sum(basic_table)*100
accuracy_train

# Sensitivity
sensitivity(basic_table)

# Specificity
specificity(basic_table)

# Precision 
precision<-diag(basic_table)[2]/(sum(basic_table[,2]))

# Recall
recall<-diag(basic_table)[2]/(sum(basic_table[2,]))

# F1 Score
2*(precision*recall)/(precision+recall)

# ROC curve
ggroc(pROC::roc(res_logit$y,round(res_logit$fitted.values)),legacy.axes=T)

varImp(res_logit) %>% arrange(desc(Overall))

# Prediction 
pred <- predict(res_logit, newdata=df_test, type="response")

# Confusion matrix
d_binomial <- tibble("target" = df_test$Survived,
                             "prediction" = round(pred))
basic_table <- table(d_binomial)
cfm <- tidy(basic_table)
plot_confusion_matrix(cfm, 
                            target_col = "target", 
                            prediction_col = "prediction",
                            counts_col = "n",
                            add_sums = TRUE,
                            sums_settings = cvms::sum_tile_settings(
                              palette = "Oranges",
                              label = "Total",
                              tc_tile_border_color = "black"
                            ))

# Performance rate
accuracy_test <- (sum(diag(basic_table)))/sum(basic_table)*100
accuracy_test

# Confusion matrix
ggroc(pROC::roc(df_test$Survived,round(pred)),legacy.axes=T)

# Predict the final values
pred_final <- predict(res_logit, newdata=test, type="response")


res=NULL
res$acc_train <- accuracy_train
res$acc_test <- accuracy_test
res$final_predict <- data.frame(PassengerId= test$PassengerId,Survived= round(pred_final))
return(res)
}


