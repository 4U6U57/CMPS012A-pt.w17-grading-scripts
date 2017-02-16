#/bin/bash
# cmps012a-pt.w17 grading
# usage: pa3.sh
# (run within your pa3 directory to test your code)

SRCDIR=https://raw.githubusercontent.com/legendddhgf/CMPS012A-pt.w17-grading-scripts/master/pa4
# Get all necessary extras

for TYPE in in model-out; do
  for NUM in $(seq 1 6); do
    curl $SRCDIR/$TYPE$NUM.txt > $TYPE$NUM.txt
  done
done

curl $SRCDIR/RootsClient.java > RootsClient.java

if [ ! -d .backup ]; then
   mkdir .backup
fi

cp *.java Makefile .backup

make

# Run tests
echo "If nothing between '=' signs, then test is passed::"
for NUM in $(seq 1 6); do
  echo "Test $NUM:"
  echo "=========="
  Roots < in$NUM.txt > out$NUM.txt
  diff -bBwu out$NUM.txt model-out$NUM.txt > diff$NUM.txt
  cat diff$NUM.txt
  echo "=========="
done

make clean

echo ""

if [ -e Roots ] || [ -e *.class ]; then
   echo "WARNING: Makefile didn't successfully clean all files"
fi

echo ""

# Compile unit tests
javac Roots.java > junkfile
javac RootsClient.java > junkfile
echo "Main-class: RootsClient" > Manifest
jar cvfm RootsClient Manifest *.class > junkfile
rm Manifest > junkfile
chmod +x RootsClient > junkfile
rm junkfile

echo "Unit Tests:"
RootsClient

rm -f *.class RootsClient Roots
