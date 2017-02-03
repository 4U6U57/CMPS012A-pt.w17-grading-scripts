#/bin/bash
# cmps012a-pt.w17 grading
# usage: pa3.sh
# (run within your pa3 directory to test your code)

SRCDIR=https://raw.githubusercontent.com/legendddhgf/CMPS012A-pt.w17-grading-scripts/master/pa3

# Get all necessary extras
for TYPE in in model-out; do
  for NUM in $(seq 1 6); do
    wget -n $SRCDIR/$TYPE$NUM.txt
  done
done

# Compile code
javac GCD.java

# Run tests
echo "If nothing between '=' signs, then test is passed::"
for NUM in $(seq 1 6); do
  echo "Test $NUM:"
  echo "=========="
  java GCD < in$NUM.txt > out$NUM.txt
  diff -bBwu out$NUM.txt model-out$NUM.txt > diff$NUM.txt
  cat diff$NUM.txt
  echo "=========="
done
rm *.class

# Delete all extras
for TYPE in in model-out; do
  for NUM in $(seq 1 6); do
    rm -f $SRCDIR/$TYPE$NUM.txt
  done
done

# Delete diff files if empty
for NUM in $(seq 1 6); do
  if [[ -z diff$NUM.txt ]]; then
    rm -f diff$NUM.txt
  fi
done
