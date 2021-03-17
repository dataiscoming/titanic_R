# Play with kaggle API
#https://medium.com/@nokknocknok/make-your-kaggle-submissions-with-kaggle-official-api-f49093c04f8a
#https://www.kaggle.com/docs/api

# See the competitions with a keywords
system("kaggle competitions list -s titanic")

# see a competition submissions history
system("kaggle competitions submissions -c titanic")

# see the head of the leaderboard
system("kaggle competitions leaderboard --show -c titanic")

# download the prediction -> does not work
system("kaggle competitions leaderboard -d -c titanic")