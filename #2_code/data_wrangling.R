# data_wrangling

# Vizualisation of data NA

df_tot <- df_1 %>%
  mutate(type = "train") %>%
  rbind(df_2 %>% 
          mutate(Survived=NA,
                 type="test"))

gg_miss_which(df_tot)

gg_miss_var(df_tot)

gg_miss_upset(df_tot)

vis_miss(df_tot)

gg_miss_fct(df_tot, Pclass)

gg_miss_fct(df_tot, Sex)

gg_miss_fct(df_tot, Embarked)

md.pattern(df_tot)

# coorection of data NA
df_tot <- df_tot %>%
  mutate(Age_2 = case_when(!is.na(Age) ~ Age,
                           is.na(Age) ~ median(Age,na.rm = T)),
         Age_3 = case_when(!is.na(Age) ~ Age,
                           is.na(Age) ~ mean(Age,na.rm = T)),
         Age_4 = case_when(!is.na(Age) ~ Age,
                           is.na(Age) ~ Mode(Age)),
         Fare_2 = case_when(!is.na(Fare) ~ Fare,
                            is.na(Fare) ~ median(Fare, na.rm = T)),
         # https://www.encyclopedia-titanica.org/titanic-survivor/martha-evelyn-stone.html
         Embarked_2 = case_when(!is.na(Embarked) ~ Embarked,
                                is.na(Embarked) ~ as.factor("S")),
         Deck = as.factor(case_when(
           str_sub(Cabin,1,1) == "T" ~ "A",
                          !is.na(Cabin) ~ str_sub(Cabin,1,1),
                          is.na(Cabin)~"M"
                          )
         )) 

vis_miss(df_tot %>% select(-Age, -Fare, -Embarked, -Cabin))

# Exploradory data analysis

# univariate analysis
# correlation for countinuous variables
corrplot(cor(df_tot %>% select(where(is.numeric)) %>% select(-Age, -PassengerId, -Fare)), 
                   type="upper", order="hclust", tl.col="black")

# Chi-square for discrete variables

# Distributions of countinuous variables # add line
hist(df_tot$Age_2, breaks = 50)
dist_plot(df = df_tot %>% filter(type=="train"), x= "Age_2", y = "Survived", bin = 5)

dist_plot(df = df_tot %>% filter(type=="train"), x= "Fare_2", y = "Survived", bin = 10)

dist_plot(df = df_tot %>% filter(type=="train"), x= "SibSp", y = "Survived", bin = 1)

dist_plot(df = df_tot %>% filter(type=="train"), x= "Parch", y = "Survived", bin = 1)

# Distributions of discrete variables 
dist_plot(df = df_tot %>% filter(type=="train"), x= "Sex", y = "Survived", bin = 1)
  
dist_plot(df = df_tot %>% filter(type=="train"), x= "Pclass", y = "Survived", bin = 1)

dist_plot(df = df_tot %>% filter(type=="train"), x= "Embarked_2", y = "Survived", bin = 1)

dist_plot(df = df_tot %>% filter(type=="train"), x= "Deck", y = "Survived", bin = 1)

# Multivariate analysis 

# PCA 

# T-SNE

# Feature enginnering
df_tot <- df_tot %>%
  mutate(Cabin_isna = as.factor(case_when(is.na(Cabin)~"1",
                           !is.na(Cabin)~"0")),
         embarked_isna = as.factor(case_when(is.na(Embarked)~"1",
                                             !is.na(Embarked)~"0")),
         family_name = str_split(Name, pattern=",", simplify = TRUE)[,1],
         Title = str_split(str_replace(Name,pattern="[.]",replacement=","), pattern=",", simplify = TRUE)[,2],
         Title_2 = as.factor(case_when(Title == " Mr" ~ "Mr",
                             Title %in% c(" Miss"," Mrs"," Ms"," Mlle"," Lady"," Mme"," the Countess"," Dona") ~ 
                               "Miss/Mrs/Ms",
                             Title == " Master" ~  "Master",
                             Title %in% c(" Dr"," Col"," Major"," Jonkheer"," Capt"," Sir"," Don"," Rev") ~
                              "Dr/Military/Noble/Clergy")),
         Fare_3 = cut(Fare_2, breaks =c(-1, 7.78, 8, 9, 10, 13, 15, 23, 26, 34, 56, 83, 513)),
         Fare_4 = cut2(Fare_2),
         age_group = as.factor(case_when(is.na(Age) ~ "No_age",
                               Age >= 0 & Age < 10 ~ "0-10",
                               Age >= 10 & Age < 30 ~ "10-30",
                               Age >= 30 & Age < 50 ~ "30-50",
                               Age >= 50 ~ "50+")),
         Age_5 = cut2(Age_2,g = 10),
         Family_size = SibSp+Parch+1,
         Family_size_2 = factor(case_when(Family_size == 1 ~ "Alone",
                                   Family_size > 1 & Family_size <= 4 ~ "Small",
                                   Family_size > 4 & Family_size <= 6 ~ "Medium",
                                   Family_size > 6 & Family_size <= 11 ~ "Large"),ordered = TRUE,
                                c("Alone","Small","Medium","Large")),
         is_married = as.factor(case_when(Title == " Mrs" ~ "1",
                                Title != " Mrs" ~ "0")))

dist_plot(df = df_tot %>% filter(type=="train"), x= "Fare_4", y = "Survived", bin = 1)

dist_plot(df = df_tot %>% filter(type=="train"), x= "age_group", y = "Survived", bin = 1)

dist_plot(df = df_tot %>% filter(type=="train"), x= "Age_5", y = "Survived", bin = 1)

dist_plot(df = df_tot %>% filter(type=="train"), x= "Family_size_2", y = "Survived", bin = 1)

dist_plot(df = df_tot %>% filter(type=="train"), x= "Title", y = "Survived", bin = 1)

dist_plot(df = df_tot %>% filter(type=="train"), x= "Title_2", y = "Survived", bin = 1)

dist_plot(df = df_tot %>% filter(type=="train"), x= "is_married", y = "Survived", bin = 1)

# Split the data in two dataset to the predictive analysis

test <- df_tot %>% filter(type == "test")

df_train <- df_tot %>% 
  filter(type == "train") %>%
  sample_frac(0.8) %>%
  select(-type)

df_test <- df_tot %>%
  filter(type == "train", 
         !PassengerId %in% df_train$PassengerId) %>%
  select(-type)
