
# Set up global variables
Asg="lab4"
PwdDir=$(pwd)
Pwd=$(basename $PwdDir)
ClassDir=$(echo $PwdDir | cut -d "/" -f -5)
Class=$(basename $ClassDir)
Student="$USER"
[[ $USER == "avalera" ]] && Student=$Pwd
StudentName=$(getent passwd $Student | cut -d ":" -f 5)
[[ $StudenName == "" ]] && StudentName="???"
BinDir="$ClassDir/bin"
AsgBinDir="$BinDir/$Asg"

# Set up testing variables and functions
GradeDir="$AsgBinDir/student"
[[ ! -e $GradeDir ]] && mkdir $GradeDir
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
touch $GradeFile
Backup=".backup"
rm -rf $Backup
mkdir $Backup
cp * $Backup

# Initial cleanup
for File in GCD GCD.class; do
  [[ -e $File ]] && rm $File
done

# Check for correct filename
for File in Makefile GCD.java; do
  if [[ -e $File ]]; then
    Score 4 4 "$File submitted and named correctly"
  else
    Score 0 0 "Could not find file: $File"
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
    SubmitTarget=$(grep "submit" Makefile)
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
    if ! grep "–" Makefile >/dev/null; then
      Score 1 1 "Makefile does not fail on clean"
    else
      Score 0 1 "Makefile fails on clean"
    fi
  else
    Score 4 4 "$File errors ignored because it was missing"
  fi
done

# Check that Makefile actually works
ErrorFile=$(mktemp)
make 2>&1 | grep -i "error" > $ErrorFile
[[ $(wc -l $ErrorFile | cut -d " " -f 1) -ne 0 ]] && Score 0 0 "Makefile target 'make' outputted errors" # && echo "output:" && cat $ErrorFile

if [[ ! -e GCD ]]; then
  Score 0 1 "Makefile does not create executable: GCD"
elif [[ ! -x GCD ]]; then
  Score 0 1 "Makefile does not give executable +x permission: GCD"
else
  Score 1 1 "Makefile correctly makes executable"
fi
make clean >/dev/null 2>&1
for File in GCD GCD.class; do
  if [[ -e $File ]]; then
    Score 0 1 "Makefile does not delete generated file: $File"
  else
    Score 1 1 "Makefile correctly cleans file: $File"
  fi
done

# Restore backed up files
for File in $Backup/*; do
  FileName=$(basename $File)
  if [[ $FileName == "GCD" || $FileName == *.class ]]; then
    cp $File $FileName
  elif [[ $FileName == "Makefile" ]] || [[ $FileName == "GCD.java" ]]; then
    if [[ ! -e $FileName ]]; then
      Score -1 0 "Makefile modified source code: $FileName"
      cp $File $FileName
    elif ! diff $FileName $File >/dev/null; then
      Score -1 0 "Makefile modified source code: $FileName"
      cp $File $FileName
    fi
  elif [[ ! -e $FileName ]] || ! diff $FileName $File >/dev/null; then
    cp $File $FileName
  fi
done

# Generate gradefile header
rm -f $GradeFile && touch $GradeFile
Print -e "CLASS:\t\t$Class"
Print -e "ASG:\t\t$Asg"
Print -e "GRADER(S):\t$(getent passwd $USER | cut -d ":" -f 5) <$USER>"
Print -e "STUDENT:\t$StudentName <$Student>"
Print -e "SCORE:\t\t$StudentScore / $MaxScore ($((StudentScore * 100 / MaxScore))%)"
Print
Print "GRADE BREAKDOWN:"
cat $ScoreFile >> $GradeFile && rm -f $ScoreFile
Print
Print "SUBMISSION INFO:"
Print && Print "Your directory listing:" && Print "$LsOrig"
[[ $CommentBlock != "" ]] && Print && Print "Your detected Makefile comment block:" && Print "$CommentBlock"
[[ $(cat $ErrorFile) != "" ]] && Print && Print "'make' errors:" && cat $ErrorFile >> $GradeFile
rm -f $ErrorFile
! grep $Asg <(echo $SubmitTarget) && Print && Print "'submit' target:" && Print "$SubmitTarget"
