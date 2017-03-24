#!/./bin/./.././bin/./bash

# table-lookup.sh
# Checks if a string is found in student's tables
# USAGE: table-lookup.sh [$ASG] $STR
#       ASG: Assginement to look up, optionally taken from directory name
#       STR: String to look up
# August Valera <avalera>

PwdDir=$(pwd)
Pwd=$(basename $PwdDir)
ClassDir=$(echo $PwdDir | cut -d "/" -f -5)
Class=$(basename $ClassDir)
Asg=""

if [[ -d "$ClassDir/$Pwd" && "$Pwd" != "bin" ]]; then
  Asg=$Pwd
  echo "Asg $Asg taken from basename of current directory"
elif [[ -d "$ClassDir/$1" ]]; then
  Asg=$1
  echo "Asg $Asg taken from first argument of script"
  shift
else
  echo "No asg provided"
  exit
fi
AsgDir=$ClassDir/$Asg
if [[ ! -d "$AsgDir" ]]; then
  echo "ERROR: Invalid asg $Asg"
  exit 1
fi

BinDir="$ClassDir/bin"
AsgBinDir="$BinDir/$Asg"
GradeDir="$AsgBinDir/student"
[[ ! -e $GradeDir ]] && mkdir $GradeDir

Query="$1"
Found=$(grep -r "$Query" $GradeDir | wc -l)
Total=$(ls $GradeDir | wc -l)
Percent=0
[[ $Total -gt 0 ]] && Percent=$((Found * 100 / Total))
echo "Found $Found matches in $Asg to '$Query' out of $Total entries ($Percent%)"
