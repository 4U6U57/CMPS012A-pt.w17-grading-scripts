#!/./bin/./.././bin/./bash

# lab6-grade.sh
# Grading script for cmps012b-pt.w17/lab6
# August Valera <avalera>

# Set up global variables
Asg="lab6"
PwdDir=$(pwd)
Pwd=$(basename $PwdDir)
ClassDir=$(echo $PwdDir | cut -d "/" -f -5)
Class=$(basename $ClassDir)
Student="$USER"
[[ $USER == "avalera" ]] && Student=$Pwd
StudentName=$(getent passwd $Student | cut -d ":" -f 5)
[[ $StudentName == "" ]] && StudentName="???"
BinDir="$ClassDir/bin"
AsgBinDir="$BinDir/$Asg"

# Set up testing variables and functions
GradeDir="$AsgBinDir/student"
[[ ! -e $GradeDir ]] && mkdir $GradeDir
GradeFile="$PwdDir/GRADE.txt"
TableFile="$GradeDir/$Student.autotable"
rm -f $GradeFile

Print() {
  echo "$@" >> $GradeFile
}

MaxScore=0
StudentScore=0
ScoreFile=$(mktemp)

Score() {
  StudentScore=$((StudentScore + $1))
  MaxScore=$((MaxScore + $2))
  ScoreString="$1 / $2 | "
  shift 2
  ScoreString+=$@
  echo $ScoreString >> $ScoreFile
}

Exe=$(basename ${BASH_SOURCE[0]})

# Table functions
declare -A StudentTable
ReadTable() {
  ClearTable
  [[ ! -e $TableFile ]] && touch $TableFile
  while read Line; do
    StudentTable["$(echo $Line | cut -d ':' -f 1)"]="$(echo $Line | cut -d ':' -f 2- | tail -c +2)"
  done < $TableFile
}
WriteTable() {
  rm -f $TableFile
  for Key in ${!StudentTable[@]}; do
    echo $Key: ${StudentTable["$Key"]} >> $TableFile
  done
  [[ ! -e $TableFile ]] && touch $TableFile
  sort $TableFile -o $TableFile
}
ClearTable() {
  for Key in ${!StudentTable[@]}; do
    unset StudentTable["$Key"]
  done
}

# Backup files just in case
Backup=".backup"
rm -rf $Backup
mkdir $Backup
cp * $Backup

ReadTable
StudentTable["ls"]="$(ls)"

# Get ErrorsFile
Key="ErrorsFile"
ErrorsFileDefault="errors"
if [[ -z "${StudentTable["$Key"]}" ]] || [[ ! -e ${StudentTable["$Key"]} ]]; then
  if [[ -e "$ErrorsFileDefault" ]]; then
    StudentTable["$Key"]="$ErrorsFileDefault"
  elif [[ -e "errors.txt" ]]; then
    StudentTable["$Key"]="errors.txt"
  else
    PS3="Select $Key for $Student: "
    select File in *; do
      StudentTable["$Key"]="$File"
      break
    done
  fi
fi

Key="DatFiles"
if [[ -z ${StudentTable["$Key"]} ]] || true; then
  Files="$(ls | grep ".dat" | sed "s/\n//g")"
  if [[ -z "$Files" ]]; then
    echo "No .dat found for $Student"
    Files="$(ls | sed "s/${StudentTable["ErrorsFile"]}//g;s/\n//g")"
  fi
  StudentTable["$Key"]="$Files"
fi

Errors=("\-?(0|[6-9]|[1-9][0-9]+)\s+\-?[0-9]" "2\s+4" "3\s+3" "4\s+\-?[0-9]+" "5\s+2" "5\s+\-?(0|[5-9]|[1-9][0-9]+)")
for I in $(seq 0 $((${#Errors[@]} - 1))); do
  Key="Error$I"
  if [[ -z ${StudentTable["$Key"]} ]]; then
    case $I in
      (0):
        Desc="(is a valid -> is not a valid) sentence code"
        ;;
      (1):
        Desc="weather here has been (hot -> cold)"
        ;;
      (2)
        Desc="plan to come home for a visit (last -> next)"
        ;;
      (3)
        Desc="buy another (books -> book)"
        ;;
      (4)
        Desc="the stuff you sent ( -> .)"
        ;;
      (5)
        Desc="Thanks for the ERROR ( -> you sent.)"
        ;;
    esac
    clear
    cat ${StudentTable["ErrorsFile"]}
    PS3="Did they find error ${Errors[$I]} $Desc?: "
    echo; echo
    select Found in true false; do
      StudentTable["$Key"]=$Found
      break
    done
  fi
  Key="Test$I"
  if [[ -z "${StudentTable["$Key"]}" ]] || true; then
    if [[ ! -z "${StudentTable["DatFiles"]}" ]] && grep -qP "${Errors[$I]}" ${StudentTable["DatFiles"]}; then
      StudentTable["$Key"]=true
    else
      StudentTable["$Key"]=false
    fi
  fi
done

for I in $(seq 0 $((${#Errors[@]} - 1))); do
  case $I in
    (0):
      Desc="(is a valid -> is not a valid) sentence code"
      ;;
    (1):
      Desc="weather here has been (hot -> cold)"
      ;;
    (2)
      Desc="plan to come home for a visit (last -> next)"
      ;;
    (3)
      Desc="buy another (books -> book)"
      ;;
    (4)
      Desc="the stuff you sent ( -> .)"
      ;;
    (5)
      Desc="Thanks for the ERROR ( -> you sent.)"
      ;;
  esac
  if ${StudentTable["Error$I"]}; then
    Score 2 2 "Found error ${Errors[$I]} ($Desc)"
  else
    Score 0 2 "Did not find error ${Errors[$I]} ($Desc)"
  fi
  if ${StudentTable["Test$I"]}; then
    Score 1 1 "Tested for error ${Errors[$I]} ($Desc)"
  else
    Score 0 1 "Did not test for error ${Errors[$I]} ($Desc)"
  fi
done

Key="ErrorsFile"
if [[ ! -z $StudentTable["$Key"] ]]; then
  if [[ ${StudentTable["$Key"]} == "errors" ]]; then
    Score 3 2 "errors file name correct: ${StudentTable["$Key"]}"
  elif [[ ${StudentTable["$Key"]} == "errors.txt" ]]; then
    Score 2 2 "errors file name acceptable: ${StudentTable["$Key"]} -> errors"
  else
    Score 1 2 "errors file name incorrect: ${StudentTable["$Key"]} -> errors"
  fi
fi

# Comment block bonus points
if [[ -e ${StudentTable["ErrorsFile"]} ]]; then
  grep "${StudentTable["ErrorsFile"]}" ${StudentTable["ErrorsFile"]} >/dev/null && Score 1 0 "Comment block contained filename: ${StudentTable["ErrorsFile"]}"
  grep "$StudentFirstName" ${StudentTable["ErrorsFile"]} >/dev/null && Score 1 0 "Comment block contained your name: $StudentFirstName"
  grep -i "$Student" ${StudentTable["ErrorsFile"]} >/dev/null && Score 1 0 "Comment block contained CruzID"
  grep -i "lab\s*6" ${StudentTable["ErrorsFile"]} >/dev/null && Score 1 0 "Comment block contained assignment name: $Asg"
fi

WriteTable

# Restore backed up files
for File in $Backup/*; do
  FileName=$(basename $File)
  if [[ ! -e $FileName ]] || ! diff $FileName $File >/dev/null; then
    cp $File $FileName
  fi
done
for File in *; do
  [[ ! -e $Backup/$File ]] && rm -f $File
done

# Generate gradefile header
[[ $StudentScore -gt $MaxScore ]] && StudentScore=$MaxScore
[[ $MaxScore -eq 0 ]] && StudentPercent=0 || StudentPercent=$((StudentScore * 100 / MaxScore))
rm -f $GradeFile && touch $GradeFile
Print -e "CLASS:\t\t$Class"
Print -e "ASG:\t\t$Asg"
Print -e "GRADER(S):\t$(getent passwd $USER | cut -d ":" -f 5) <$USER>"
Print -e "STUDENT:\t$StudentName <$Student>"
Print -e "SCORE:\t\t$StudentScore / $MaxScore ($StudentPercent%)"
Print
Print "GRADE BREAKDOWN:"
Print
cat $ScoreFile >> $GradeFile && rm -f $ScoreFile
Print
Print "SUBMISSION INFO:"
Print && Print "Your directory listing:" && Print "${StudentTable["ls"]}"
Print
Print "GRADING INFO:"
Print
RubricUrl=""
Print "$(echo "For questions or concerns about your grade, please send a REPLY to this email from your UCSC account. If you believe your assignment has been graded in error, please include the word 'REVIEW' in all caps in your message body, with information on what you think the error was. Note that doing so allows us to review your entire assignment, which, while unlikely, may result in an overall lower score. Aside from the review, you may ask any questions about your submission without fear of penalty. The assignment rubric, with extra information on how to read the errors, can be found on GitHub ($RubricUrl)." | fmt)"
sed -i 's/\r//g' $GradeFile
