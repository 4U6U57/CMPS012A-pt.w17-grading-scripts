#!/./bin/./.././bin/./bash

# lab4-check.sh
# Checking script for cmps012b-pt.w17/lab4
# August Valera <avalera>

# Set up global variables
Asg="lab4"
PwdDir=$(pwd)
Pwd=$(basename $PwdDir)
Student="$USER"
StudentName=$(getent passwd $Student | cut -d ":" -f 5)

# Set up testing variables and functions
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
Testing() {
  echo
  echo "[TEST]: $@"
}

# Print start prompt
Exe=$(basename ${BASH_SOURCE[0]})
echo "[START]: $Exe"
echo
Warn "this script is provided 'as is' to test your code, please do not abuse it."
echo "Also note that it may have been updated since you last downloaded it."
[[ "$Pwd" != "$Asg" ]] && echo && Warn "working directory not named same as assignment" && echo "pwd: $PwdDir"

# Backup files just in case
Backup=".backup"
rm -rf $Backup
mkdir $Backup
cp * $Backup

# Initial cleanup
for File in GCD GCD.class; do
  [[ -e $File ]] && Warn "Started script with already compiled file, deleting: $File" && rm $File
done

# Check for correct filename
Testing "filenames"
Makefile="Makefile"
[[ ! -e $Makefile ]] && Error "could not find file: $Makefile" && echo "ls: $(ls -m)"

# Check comment block
Testing "comment blocks"
for File in $Makefile; do
  if [[ -e $File ]]; then
    CommentBlock=$(head -n 10 $File | grep -xa "\s*[/*#].*")
    StudentFirstName=$(echo $StudentName | cut -d " " -f 1)
    ErrorFlag=false
    ! grep -q "$File" <(echo $CommentBlock) && Warn "$File comment block mising filename: $File" && ErrorFlag=true
    ! grep -q "$StudentFirstName" <(echo $CommentBlock) && Warn "$File comment block missing your name: $StudentFirstName" && ErrorFlag=true
    ! grep -q "$Student" <(echo $CommentBlock) && Error "$File comment block missing CruzID: $Student" && ErrorFlag=true
    ! grep -q "$Asg" <(echo $CommentBlock) && Error "$File comment block missing assignment name: $Asg" && ErrorFlag=true
    [[ $ErrorFlag == true ]] && echo "comment block: $Makefile" && echo "$CommentBlock"
  fi
done

# Check common errors in Makefile contents
Testing "$Makefile contents"
for File in $Makefile; do
  if [[ -e $File ]]; then
    ! grep "submit" $Makefile | grep -q "lab4" && Error "$Makefile not configured to submit to lab4" && grep "submit" $Makefile
    grep -q "HelloWorld" $Makefile && Error "$Makefile contains reference to HelloWorld" && grep "HelloWorld" $Makefile
    grep -q "–" $Makefile && Error "$Makefile copied from PDF, contains invalid character in clean target" && grep "–" $Makefile
  fi
done

# Check that Makefile actually works
Testing "$Makefile behavior"
ErrorFile=$(mktemp)
make >/dev/null 2>$ErrorFile
[[ $(wc -l $ErrorFile | cut -d " " -f 1) -ne 0 ]] && Error "$Makefile target 'make' outputted errors" && echo "output:" && cat $ErrorFile
if [[ ! -e GCD ]]; then
  Error "$Makefile does not create executable: GCD"
  echo "ls: $(ls -m)"
  echo "Temp GCD made by $Exe" > GCD
else
  [[ ! -x GCD ]] && Error "Executable does not have +x permission: GCD"
fi
make clean >/dev/null
for File in GCD GCD.class; do
  [[ -e $File ]] && Error "$Makefile does not delete generated file: $File" && echo "ls: $(ls -m)" && rm -f $File
done

# Restore backed up files
Testing "File modification/deletion"
for File in $Backup/*; do
  FileName=$(basename $File)
  if [[ $FileName == "GCD" || $FileName == *.class ]]; then
    echo "Restoring preexisting compiled file: $FileName"
    cp $File $FileName
  elif [[ ! -e $FileName ]]; then
    Error "SUPER BAD: running tests deleted file: $FileName"
    cp $File $FileName
  elif ! diff -u $FileName $File; then
    Error "SUPER BAD: running tests modified file: $FileName"
    cp $File $FileName
  fi
done

# Print results
echo
ErrorString="errors"
WarnString="warnings"
[[ $ErrorCount -eq 1 ]] && ErrorString="error"
[[ $WarnCount -eq 1 ]] && WarnString="warning"
echo "Finished with $ErrorCount $ErrorString and $WarnCount $WarnString"
echo "[STOP]: $Exe"
