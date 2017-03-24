# cmps012a-pt.w17/lab6

Unfortunately, it isn't really possible to distribute a testing script for lab6,
as the submittables are only a plaintext list of errors `errors`, and test input
files to demonstrate these errors.

In lieu of that, since the assignment has already been turned in, I am providing
a solution script that runs the faulty executable on every possible input in the
range [0-6] for both the sentence code and modifier, and diffs it with the
expected output. This is similar to what you should be done in the lab, and as
it is not particularly hard to do this yourself (create an input file with
contents 0 0 0 1 0 2 0 3 0 4 0 5 0 6 1 0 1 1 .. and run it) the results should
come at no surprise. Of course, since some of the errors affect a range of
inputs (fake example: 1 \*) the number of actual errors is not the sum of diffs.

## Assignment Rubric

The rubric for this assignment can be found [here](RUBRIC.md).

## Installation

> By using this script, you agree to the linked
> [disclaimers](../lib/DISCLAIMER.md).

Run the following in any directory to download the latest version of the test
script. You should have the faulty LetterHome executable present in the same
folder.

```bash
curl https://raw.githubusercontent.com/legendddhgf/CMPS012A-pt.w17-grading-scripts/master/lab6/lab6-solution.sh > lab6-solution.sh
chmod +x lab6-solution.sh
```

## Usage

After downloading the script, you can run it with the following command:

```bash
./lab6-solution.sh
```

The output is a series of diffs, an example shown below

```diff
- This is an error.
+ This is correct.
```

This is a diff patch output, meaning that the lines prefixed with a `-` are
from the actual output (and are incorrect), while the `+` lines are those that
we expect instead. In short, in order to make the output correct, we would need
to `-` delete some lines, and `+` add in other lines.

## Removal

Once you are done testing your program, you can delete the script the usual way
with `rm lab6-solution.sh`. This script does not create any other files.
