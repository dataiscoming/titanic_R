# data_import

# Train data
df_1 <- read.csv("#1_input/titanic/train.csv",stringsAsFactors = F) %>%
  mutate(Cabin = case_when(Cabin != "" ~ Cabin),
         Embarked = case_when(Embarked != ""  ~ Embarked),
        Survived = as.factor(Survived),
        Pclass = as.factor(Pclass),
        Sex = as.factor(Sex),
        Embarked = as.factor(Embarked))

# Test data
df_2 <- read.csv("#1_input/titanic/test.csv") %>%
  mutate(Cabin = case_when(Cabin != "" ~ Cabin),
         Pclass = as.factor(Pclass),
         Sex = as.factor(Sex),
         Embarked = as.factor(Embarked))
