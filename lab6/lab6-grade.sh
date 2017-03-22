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
PiazzaUrl="http://piazza.com"

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
if [[ -z ${StudentTable["$Key"]} ]]; then
  Files="$(ls | grep ".dat" | sed "s/\n//g")"
  if [[ -z "$Files" ]]; then
    echo "No .dat found for $Student"
    Files="$(ls | sed "s/${StudentTable["ErrorsFile"]}//g;s/\n//g")"
  fi
  StudentTable["$Key"]="$Files"
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
Print && Print "Your directory listing:" && Print "$LsOrig"
Print && [[ $CommentBlock != "" ]] && (Print "Your detected Makefile comment block:" && Print "$CommentBlock") || Print "No Makefile comment block detected."
[[ $MakeError != "" ]] && Print && Print "'make' errors:" && Print "$MakeError"
[[ $CleanError != "" ]] && Print && Print "'make clean' errors:" && Print "$CleanError"
([[ $SubmitTarget == "" ]] && Print && Print "No submit target found") || (! grep $Asg <(echo $SubmitTarget) >/dev/null && Print && Print "'submit' target:" && Print "$SubmitTarget")
Print
Print "GRADING INFO:"
Print
Print "$(echo "For questions or concerns about your grade, please send a REPLY to this email from your UCSC account. If you believe your assignment has been graded in error, please include the word 'REVIEW' in all caps in your message body, with information on what you think the error was. Note that doing so allows us to review your entire assignment, which, while unlikely, may result in an overall lower score. Aside from the review, you may ask any questions about your submission without fear of penalty. The assignment rubric can be found on Piazza ($PiazzaUrl), and was loosely based off of the check script provided prior to the assignment deadline." | fmt)"
sed -i 's/\r//g' $GradeFile
