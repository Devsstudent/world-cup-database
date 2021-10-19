#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TRUNC=$($PSQL "TRUNCATE TABLE teams, games;")
cat "games.csv" | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if (( $YEAR != 'year'))
  then
    if [[ $($PSQL "SELECT team_id  FROM teams WHERE name='$WINNER';") == "" ]]
    then
            INSERT_W_ID=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER');")
    fi
    if [[ $($PSQL "SELECT team_id  FROM teams WHERE name='$OPPONENT';") == "" ]]
    then
            INSERT_O_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
    fi
    W_ID=$($PSQL "SELECT team_id  FROM teams WHERE name='$WINNER';")
    O_ID=$($PSQL "SELECT team_id  FROM teams WHERE name='$OPPONENT';")
    INSERT_DATA=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $W_GOALS, $O_GOALS, $W_ID, $O_ID);") 
  fi
done

