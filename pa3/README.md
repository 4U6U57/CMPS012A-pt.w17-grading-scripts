# cmps012a-pt.w17/pa1

The following is a set of performance tests to run on your GCD program. It takes six example input files and compares your results to our correct model outputs. We have made this available to you to check your work before making your final submission.

## Installation

Run the following in your working directory (the directory you wrote your code in) to get the test script and example input files:

```bash
SRCDIR=https://raw.githubusercontent.com/legendddhgf/CMPS012A-pt.w17-grading-scripts/master/pa3
for TYPE in in model-out; do
    for NUM in $(seq 1 6); do
        wget $SRCDIR/$TYPE$NUM.txt
    done
done
wget $SRCDIR/pa3.sh
chmod +x pa3.sh
```

## Usage

After installation, you can run the script with this line:

```bash
./pa3.sh
```

It will print out the difference between your output and the correct output, using the `diff` command. Lack of any output between the set of "==========" means that your program is running correctly.

WARNING: For now on you will not get a perfect score if there is any
output between any of the pairs of equal signs

## Removal

The following command will remove all text files and shell scripts in your directory. Since you should not have any files that end in `.txt` or `.sh` anyway, this should serve to delete all the files we gave you.

```bash
rm -f *.txt *.sh
```
