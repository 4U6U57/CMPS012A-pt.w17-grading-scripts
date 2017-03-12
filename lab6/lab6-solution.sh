#!/./bin/./.././bin/./bash

# lab6-solution.sh
# Solution script for cmps012b-pt.w17/lab4
# August Valera <avalera>

# Set up global variables
Asg="lab4"
PwdDir=$(pwd)
Pwd=$(basename $PwdDir)
Student="$USER"
StudentName=$(getent passwd $Student | cut -d ":" -f 5)

SentenceMin=0
SentenceMax=6
ModifierMin=0
ModifierMax=6

LetterEmulate() { # (filename)
  Input="$(cat $1 | sed 's/\r//g')"
  echo "Dear Mom and Dad:"
  echo
  LetterProcess $Input
}

LetterProcess() { # (sent mod [sent mod]...)
  if [[ $@ != "" ]]; then
    Sent=$1
    Mod=$2
    LetterEvaluate $Sent $Mod
    shift 2
    LetterProcess $@
  fi
}

LetterEvaluate() { # (sent mod)
  Sent=$1
  Mod=$2
  Sentence="UNDEF"
  Modifier="UNDEF"
  case $Sent in
    (1)
      case $Mod in
        (1) Modifier="great"
          ;;
        (2) Modifier="ok"
          ;;
        (*) Modifier="ERROR"
          ;;
      esac
      Sentence="My classes are going $Modifier."
      ;;
    (2)
      case $Mod in
        (1) Modifier="great"
          ;;
        (2) Modifier="foggy"
          ;;
        (3) Modifier="hot"
          ;;
        (4) Modifier="cold"
          ;;
        (5) Modifier="variable"
          ;;
        (*) Modifier="ERROR"
          ;;
      esac
      Sentence="The weather here has been $Modifier."
      ;;
    (3)
      case $Mod in
        (1) Modifier="after the quarter ends"
          ;;
        (2) Modifier="in a few weeks"
          ;;
        (3) Modifier="next weekend"
          ;;
        (*) Modifier="ERROR"
          ;;
      esac
      Sentence="I plan to come home for a visit $Modifier."
      ;;
    (4)
      Sentence="Do you think you could send me \$$Mod?"
      Sentence+=$'\n'
      Sentence+="I have to buy another book for one of my classes."
      ;;
    (5)
      case $Mod in
        (1) Modifier="cookies"
          ;;
        (2) Modifier="stuff"
          ;;
        (3) Modifier="money"
          ;;
        (*) Modifier="ERROR"
          ;;
      esac
      Sentence="Thanks for the $Modifier you sent."
      ;;
    (*)
      Sentence="$Sent is not a valid sentence code"
      ;;
  esac
  echo "$Sentence"
}

[ ! -e LetterHome.class ] && scp $USER@unix.ucsc.edu:/afs/cats.ucsc.edu/users/f/ptantalo/public/LetterHome.class .
[ ! -e LetterHome.class ] && echo "You must run this script with LetterHome.class in the folder" && exit 1

for Sentence in $(seq $SentenceMin $SentenceMax); do
  #echo -n "$Sentence: "
  for Modifier in $(seq $ModifierMin $ModifierMax); do
    TempFile=$(mktemp)
    echo "$Sentence $Modifier" > $TempFile
    diff -u <(LetterEmulate $TempFile) <(java LetterHome $TempFile) || (echo "Discrepancy found with input $Sentence $Modifier" && echo && echo)
    rm -f $TempFile
  done
  #echo
done
