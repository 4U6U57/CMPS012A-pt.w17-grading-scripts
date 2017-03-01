#!/bin/bash
# cmps012a-pt.w17 grading
# usage: pa3.sh
# (run within your pa3 directory to test your code)

SRCDIR=https://raw.githubusercontent.com/legendddhgf/CMPS012A-pt.w17-grading-scripts/master/pa5
# Get all necessary extras

curl $SRCDIR/QueensUnitTests.java > QueensUnitTests.java

if [ ! -d .backup ]; then
   mkdir .backup
fi

cp *.java Makefile .backup

make

TEST1=""
TEST2="x"
TEST3="-v"
TEST4="-v x"
TEST5="5"
TEST6="-v 5"
TEST7="8"
TEST8="-v 8"
TEST9="11"
TEST10="-v 11"

# Run tests
echo "If nothing between '=' signs, then test is passed::"
echo "Test 1:"
echo "=========="
Queens $TEST1 > out1.txt
diff -bBwu out1.txt model-out1.txt > diff1.txt
cat diff1
echo "=========="

echo "Test 2:"
echo "=========="
Queens $TEST2 > out2.txt
diff -bBwu out2.txt model-out2.txt > diff2.txt
cat diff2
echo "=========="

echo "Test 3:"
echo "=========="
Queens $TEST3 > out3.txt
diff -bBwu out3.txt model-out3.txt > diff3.txt
cat diff3
echo "=========="

echo "Test 4:"
echo "=========="
Queens $TEST4 > out4.txt
diff -bBwu out4.txt model-out4.txt > diff4.txt
cat diff4
echo "=========="

echo "Test 5:"
echo "=========="
Queens $TEST5 > out5.txt
diff -bBwu out5.txt model-out5.txt > diff5.txt
cat diff5
echo "=========="

echo "Test 6:"
echo "=========="
Queens $TEST6 > out6.txt
diff -bBwu out6.txt model-out6.txt > diff6.txt
cat diff6
echo "=========="

echo "Test 7:"
echo "=========="
Queens $TEST7 > out7.txt
diff -bBwu out7.txt model-out7.txt > diff7.txt
cat diff7
echo "=========="

echo "Test 8:"
echo "=========="
Queens $TEST8 > out8.txt
diff -bBwu out8.txt model-out8.txt > diff8.txt
cat diff8
echo "=========="

echo "Test 9:"
echo "=========="
Queens $TEST9 > out9.txt
diff -bBwu out9.txt model-out9.txt > diff9.txt
cat diff9
echo "=========="

echo "Test 10:"
echo "=========="
Queens $TEST10 > out10.txt
diff -bBwu out10.txt model-out10.txt > diff10.txt
cat diff10
echo "=========="



make clean

echo ""

if [ -e Queens ] || [ -e *.class ]; then
   echo "WARNING: Makefile didn't successfully clean all files"
fi

echo ""

# Compile unit tests
javac Queens.java > junkfile
javac QueensUnitTests.java > junkfile
echo "Main-class: QueensUnitTests" > Manifest
jar cvfm QueensUnitTests Manifest *.class > junkfile
rm Manifest > junkfile
chmod +x QueensUnitTests > junkfile
rm junkfile

echo "Unit Tests:"
#QueensUnitTests
echo "NOT YET"

rm -f *.class Queens QueensUnitTests
