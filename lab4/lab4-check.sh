#!/bin/bash

# lab4-check.sh
# Checking script for cmps012b-pt.w17/lab4
# August Valera <avalera>

# Set up variables
Asg="lab4"
PwdDir=$(pwd)
Pwd=$(basename $PwdDir)
Student="$USER"
StudentName=$(getent passwd $Student | cut -d ":" -f 5)

ErrorCount=0
Error() {
  echo "ERROR: $@"
  ErrorCount=$(($ErrorCount + 1))
}
WarnCount=0
Warn() {
  echo "WARN: $@"
  WarnCount=$(($WarnCount + 1))
}

# Print start prompt
Exe=$(basename ${BASH_SOURCE[0]})
echo "$Exe"
echo
Warn "this script is not finalized"
[[ "$Pwd" != "$Asg" ]] && Warn "working directory not named same as assignment"
echo "pwd: $PwdDir"

# Backup files just in case
Backup=".backup"
rm -rf $Backup
mkdir $Backup
cp * $Backup

# Check for correct filename
Makefile="Makefile"
[[ ! -e $Makefile ]] && Error "could not find file: $Makefile" && echo "ls: $(ls -m)"

# Check comment block
for File in $Makefile; do
  if [[ -e $File ]]; then
    CommentBlock=$(head -n 10 $File | grep -xa "\s*[/*#].*")
    ! grep -q "$Asg" <(echo $CommentBlock) && Error "$Makefile comment block missing assignment: $Asg"
    ! grep -q "$Student" <(echo $CommentBlock) && Error "$Makefile comment block missing CruzID: $Student"
  fi
done

# Check common errors in Makefile
for File in $Makefile; do
  if [[ -e $File ]]; then
    ! grep "submit" $Makefile | grep -q "lab4" && Error "$Makefile not configured to submit to lab4" && grep "submit" $Makefile
    grep -q "HelloWorld" $Makefile && Error "$Makefile contains reference to HelloWorld" && grep "HelloWorld" $Makefile
    grep -q "–" $Makefile && Error "$Makefile copied from PDF, contains invalid character in clean target" && grep "–" $Makefile
  fi
done

# Restore backed up files
for File in $Backup/*; do
  FileName=$(basename $File)
  if [[ ! -e $FileName ]]; then
    Error "running tests deleted file: $FileName"
    cp $File $FileName
  elif ! diff -u $FileName $File; then
    Error "running tests modified file: $FileName"
    cp $File $FileName
  fi
done

# Print results
echo
echo "$Exe finished with $ErrorCount errors and $WarnCount warnings"
