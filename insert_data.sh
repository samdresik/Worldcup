#!/bin/bash

if [[ $1 == "test" ]]
  then
    PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
  else
    PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
 
 #first we insert into team
 if [[ $WINNER != 'winner' ]]
  then 
   #get winner id
   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    
    #if not found
     if [[ -z $WINNER_ID ]]
      then
       INSERT_WINNER_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        
        #insert winner
        if [[ $INSERT_WINNER_ID == "INSERT 0 1" ]]
         then
         echo Inserted into teams, $WINNER
        fi
        
        #get winner id
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
     fi
 fi
  
 if [[ $OPPONENT != 'opponent' ]]
  then
  #get opponent id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #if not found
    if [[ -z $OPPONENT_ID ]]
     then
      INSERT_OPPONENT_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      #insert opponent id
       if [[ $INSERT_OPPONENT_ID == "INSERT 0 1" ]]
        then
         echo Inserted into teams, $OPPONENT
       fi
      #get opponent id
       OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  fi 
        
  # second we insert into games
  if [[ $YEAR != 'year' ]]
    then 
     INSERT_INTO_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
  echo Inserted into games, $WINNER VS $OPPONENT in $YEAR $ROUND.
done
