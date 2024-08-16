#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# We're deleting all data in the relation each time before the script starts insering data in it, so each time our script will be running it will always be finding our relations are empty
echo $($PSQL "TRUNCATE teams, games")

  cat games.csv | while IFS="," read YEAR ROUND TEAM_1 TEAM_2 WINNER_GOALS OPPONENT_GOALS
   do
   if [[ $TEAM_1 != 'winner' ]]
   then
   #we check if that team is already inserted in the teams relation
   TEAM_AVAILABILITY1=$($PSQL "SELECT name FROM teams WHERE name ='$TEAM_1'")

   #if not then we add it
   if [[ -z $TEAM_AVAILABILITY1 ]]
    then 
     INSERTED_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM_1')")
          
   fi
  fi

  if [[ $TEAM_2 != 'opponent' ]]
  then
  #we check if that team is already inserted in the teams relation
   TEAM_AVAILABILITY2=$($PSQL "SELECT name FROM teams WHERE name ='$TEAM_2'")

  #if not then we add it
   if [[ -z $TEAM_AVAILABILITY2 ]]
    then 
     INSERTED_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM_2')")
    
   fi
  fi

  #getting winner_id/TEAM_1 ID
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM_1'")
  
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM_2'") 
  
  INSERTED_INTO_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  #round

  done

