#!/./bin/./.././bin/./bash

# lab4-grade.sh
# Grading script for cmps012b-pt.w17/lab4
# August Valera <avalera>

# Set up global variables
Asg="lab4"
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
GradeFile="$Pwd/GRADE.txt"
GradeFile="$GradeDir/$Student.GRADE.txt"
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

# Backup files just in case
LsOrig=$(ls -m)
Backup=".backup"
rm -rf $Backup
mkdir $Backup
cp * $Backup

# Initial cleanup
for File in GCD GCD.class; do
  [[ -e $File ]] && rm $File
done

# Check for correct filename
Source="GCD.java"
for File in Makefile $Source; do
  if [[ -e $File ]]; then
    Score 4 4 "$File submitted and named correctly"
  else
    if [[ $File == $Source ]]; then
      for AltSource in GDC.java gcd.java; do
        [[ -e $AltSource ]] && Source=$AltSource
      done
      HelloWorldUrl="https://classes.soe.ucsc.edu/cmps012a/Winter17/Examples/HelloName.java"
      if [[ $File == $Source ]]; then
        Score 0 4 "Could not find file: $File"
        curl -s $HelloWorldUrl > $Source
      else
        Score 2 4 "Incorrectly named file: $Source -> GCD.java"
      fi
    elif [[ $File == Makefile ]]; then
      Score 0 4 "Could not find file: $File"
    fi
  fi
done

# Check comment block
for File in Makefile; do
  if [[ -e $File ]]; then
    CommentBlock="$(head -n 10 $File | grep -xa "\s*[/*#].*")"
    StudentFirstName=$(echo $StudentName | cut -d " " -f 1)
    if [[ $(wc -c <(echo $CommentBlock) | cut -d ' ' -f 1) -ne 0 ]]; then
      Score 2 2 "$File contained comment block"
    else
      Score 1 2 "$File did not contain comment block"
    fi
    ! grep "$File" <(echo $CommentBlock) >/dev/null && Score 0 0 "$File comment block mising filename: $File"
    ! grep "$StudentFirstName" >/dev/null <(echo $CommentBlock) && Score 0 0 "$File comment block missing your name: $StudentFirstName"
    if grep "$Student" >/dev/null <(echo $CommentBlock); then
      Score 1 1 "$File comment block contained CruzID"
    else
      Score 0 1 "$File comment block missing CruzID: $Student"
    fi
    if grep -i "lab\s*4" >/dev/null <(echo $CommentBlock); then
      Score 1 1 "$File comment block contained assignment name"
    else
      Score 0 1 "$File comment block missing assignment name: $Asg"
    fi
  else
    Score 4 4 "$File comment block ignored because it was missing"
  fi
done

# Check common errors in Makefile contents
for File in Makefile; do
  if [[ -e $File ]]; then
    SubmitTarget="$(grep "submit" Makefile)"
    if grep $Asg <(echo $SubmitTarget) >/dev/null; then
      Score 1 1 "Makefile submit target set to correct assignment"
    else
      Score 0 1 "Makefile not configured to submit to $Asg"
    fi
    if ! grep "HelloWorld" <(cat Makefile | sed 's/#.*//g') >/dev/null; then
      Score 1 1 "Makefile converted from GCD to HelloWorld"
    else
      Score 0 1 "Makefile contains reference to HelloWorld"
    fi
    #if ! grep "–" Makefile >/dev/null; then
    #  Score 1 1 "Makefile does not fail on clean"
    #else
    #  Score 0 1 "Makefile fails on clean"
    #fi
  else
    Score 2 2 "$File errors ignored because it was missing"
  fi
done

# Check that Makefile actually works
if [[ -e Makefile ]]; then
  SourceExe=$(basename $Source .java)
  MakeError=$(make 2>&1 >/dev/null)
  if [[ ! -e $SourceExe ]]; then
    Score 0 1 "Makefile does not create executable: $SourceExe"
    echo "SAMPLE $SourceExe TO TEST MAKE CLEAN" > $SourceExe
    echo "SAMPLE $SourceExe.class TO TEST MAKE CLEAN" > $SourceExe.class
  elif [[ ! -x $SourceExe ]]; then
    Score 0 1 "Makefile does not give executable +x permission: $SourceExe"
  else
    Score 1 1 "Makefile correctly makes executable"
  fi
  CleanError=$(make clean 2>&1 >/dev/null)
  for File in $SourceExe $SourceExe.class Manifest; do
    if [[ -e $File ]]; then
      Score 0 1 "Makefile does not delete generated file: $File"
      rm -f $File
    else
      Score 1 1 "Makefile correctly cleans file: $File"
    fi
  done
else
  Score 0 4 "Makefile could not be tested because it was missing"
fi

# Restore backed up files
SafetyPoints=2
SafetyError=""
for File in $Backup/*; do
  FileName=$(basename $File)
  if [[ $FileName == "Makefile" ]] || [[ $FileName == $Source ]]; then
    if [[ ! -e $FileName ]]; then
      echo $((SafetyPoints--)) >/dev/null
      SafetyError+="deleted $FileName,"
    elif ! diff $FileName $File >/dev/null; then
      echo $((SafetyPoints--)) >/dev/null
      SafetyError+="modified $FileName,"
    fi
  fi
  if [[ ! -e $FileName ]] || ! diff $FileName $File >/dev/null; then
    cp $File $FileName
  fi
done
for File in *; do
  [[ ! -e $Backup/$File ]] && rm -f $File
done
[[ $SafetyError != "" ]] && SafetyError=" : $(echo "$SafetyError" | head -c -2)"
Score $SafetyPoints 2 "Submission safety $SafetyError"

# Generate gradefile header
rm -f $GradeFile && touch $GradeFile
Print -e "CLASS:\t\t$Class"
Print -e "ASG:\t\t$Asg"
Print -e "GRADER(S):\t$(getent passwd $USER | cut -d ":" -f 5) <$USER>"
Print -e "STUDENT:\t$StudentName <$Student>"
Print -e "SCORE:\t\t$StudentScore / $MaxScore ($((StudentScore * 100 / MaxScore))%)"
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
Print "$(echo "For questions or concerns about your grade, please send a REPLY to this email from your UCSC account. If you believe your assignment has been graded in error, please include the word 'REVIEW' in all caps in your message body, with information on what you think the error was. Note that doing so allows us to review your entire assignment, which, while unlikely, may result in an overall lower score. Aside from the review, you may ask any questions about your submission without fear of penalty. The assignment rubric will be made available on Piazza shortly, and was loosely based off of the check script provided prior to the assignment deadline." | fmt)"
