# index of codes

# load functions
files.sources = list.files(path="#2_code/functions/")
sapply(files.sources, FUN=function(x) source(paste0("#2_code/functions/",x), encoding = "UTF-8"))

# Packages 
source(file = "#2_code/packages.R",encoding = "UTF-8")

# Data import
source(file = "#2_code/data_import.R",encoding = "UTF-8")

# Data wrangling
source(file = "#2_code/data_wrangling.R",encoding = "UTF-8")

# Model 1 : Logit model
res1<-logit() #res test data => 0.75
compare_results <- data.frame("Name"="glm1",acc_train=res1$acc_train, acc_test=res1$acc_test)
write.csv(x = res1$final_predict, file = "#3_output/res_logit_1.csv",row.names = F)
system('kaggle competitions submit -c titanic -f "#3_output/res_logit_1.csv" -m "first submission for a logit model"') # submit a file 

#  further model to come ...
#cross validation / stepwise regression /Decision trees / Elastic net regularization /
#Penalized Logistic Regression Essentials in R: Ridge, Lasso and Elastic Net