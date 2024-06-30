#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get opponnent_id
    OP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'") 

    # if not found
    if [[ -z $OP_ID ]]
    then
      # insert opponent
      INSERT_OP_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OP_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi

      # get new opponent_id
      OP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'") 
    fi


    # get WINNER_id
    WI_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # if not found
    if [[ -z $WI_ID ]]
    then
      # insert winner
      INSERT_WI_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WI_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into team, $WINNER
      fi

      # get new winner_id
      WI_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi




    # insert games data
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year,round,winner_goals,opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WI_ID, $OP_ID)")
      if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into team, $YEAR $ROUND $WINNER_GOALS $OPPONENT_GOALS $WI_ID $OP_ID
      fi


  fi
done