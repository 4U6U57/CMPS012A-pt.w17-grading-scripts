#/bin/bash
# cmps012a-pt.w17 grading
# usage: pa3.sh
# (run within your pa3 directory to test your code)

SRCDIR=https://raw.githubusercontent.com/legendddhgf/CMPS012A-pt.w17-grading-scripts/master/pa4
# Get all necessary extras

#for TYPE in in model-out; do
#  for NUM in $(seq 1 5); do
#    curl $SRCDIR/$TYPE$NUM.txt > $TYPE$NUM.txt
#  done
#done


# TODO: update to reflect the fact that you must use a Makefile
# Compile code
javac Roots.java

# Run tests
echo "If nothing between '=' signs, then test is passed::"
for NUM in $(seq 1 5); do
  echo "Test $NUM:"
  echo "=========="
  java Roots < in$NUM.txt > out$NUM.txt
  diff -bBwu out$NUM.txt model-out$NUM.txt > diff$NUM.txt
  cat diff$NUM.txt
  echo "=========="
done

rm -f *.class

