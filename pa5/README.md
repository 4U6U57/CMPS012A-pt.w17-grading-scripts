# cmps012a-pt.w17/pa5

The following is a set of performance tests to run on your Roots program.
We have made this available to you to check your work before making your final
submission.

General performance tests 1-8 give your program 0.5 seconds.
Test 9 and 10 give you 2 seconds (because they test 11-Queens)

isSolution test 1 expects false while isSolution test 2 expects true
nextPermutation tests two cases of running nextPermutation (partial
reverse and full reverse)

## Warning

This script should confirm all components of your performance based grade but
doesn't confirm every component of your grade for things like comment blocks
(It'll definitely get you most of the points though)

## Installation

Run the following in your working directory (the directory you wrote your code
in) to download the test script.

```bash
curl https://raw.githubusercontent.com/legendddhgf/CMPS012A-pt.w17-grading-scripts/master/pa5/pa5.sh > pa5.sh
chmod +x pa5.sh
```

# Usage

After downloading the script, you can then run it with the following command:

```bash
./pa5.sh
```

It will print out the difference between your output and the correct output,
using the `diff` command. Lack of any output between the set of "=========="
means that your program is running correctly.

> WARNING: For now on you will not get a perfect score if there is any output
between any of the pairs of equal signs or if any unit tests fail

## Removal

The test script should be self cleaning, removing the test input and model-out
files that we have downloaded. You can delete the test and all other downloaded
files with:
`rm -f pa5.sh diff*.txt out*.txt model-out*.txt QueensUnitTests.java`
