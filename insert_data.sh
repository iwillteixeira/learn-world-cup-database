#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE games,teams")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
 if [[ $YEAR != 'year' ]]
 then
 #check if there is already this team
 echo "$WINNER $OPPONENT"
 TEAM_ONE="$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")"
 TEAM_TWO="$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")"
   if [[ -z $TEAM_ONE ]]
   then
   INSERTED_TEAM="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
    if [[ $INSERTED_TEAM == 'INSERT 0 1' ]]
    then
    echo "Team $WINNER was inserted"
    fi
   fi 
   if [[ -z $TEAM_TWO ]]
    then
   INSERTED_TEAM="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
    if [[ $INSERTED_TEAM == 'INSERT 0 1' ]]
    then
    echo "Team $WINNER was inserted"
    fi
   fi
   WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
   OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
   GAME_ADDED="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")"
    if [[ $GAME_ADDED == 'INSERT 0 1' ]]
    then
    echo "GAME ADDED WINNER: $WINNER"
    fi 
fi
done
