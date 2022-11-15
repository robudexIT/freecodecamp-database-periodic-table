PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

QUERY_DB(){
  if [[ -z $1 ]]
  then
      echo  "I could not find that element in the database."
  else
      echo "$ELEMENT" | while IFS="|" read TYPE_ID  ATOMIC_NUMBER SYMBOL  NAME  ATOMIC_MASS  MELTING_POINT_CELSIUS  BOILING_POINT_CELSIUS  TYPE
      do 
         # "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
         echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
  fi

}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
   if [[ $1 =~ ^[0-9]+$ ]]
    then
      ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
      QUERY_DB $ELEMENT
   else
      ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE  symbol='$1' OR name='$1'")
      QUERY_DB $ELEMENT
   fi
fi
