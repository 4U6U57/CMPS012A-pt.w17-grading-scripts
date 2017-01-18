#/bin/bash

#if [ -z $DIR ]
#then
#   DIR=.
#fi

javac Lawn.java
echo "If nothing between '=' signs, then test is passed::"
echo "Test 1:"
echo "=========="
java Lawn < in1.txt > out1.txt
diff out1.txt model-out1.txt > diff1.txt
cat diff1.txt
echo "=========="
echo "Test 2:"
echo "=========="
java Lawn < in2.txt > out2.txt
diff out2.txt model-out2.txt > diff2.txt
cat diff2.txt
echo "=========="
echo "Test 3:"
echo "=========="
java Lawn < in3.txt > out3.txt
diff out3.txt model-out3.txt > diff3.txt
cat diff3.txt
echo "=========="
rm *.class
