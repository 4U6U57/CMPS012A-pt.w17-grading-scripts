# cmps012a-pt.w17/lab4

Here's a script to test your lab4. It's not done, but it should be good enough
for now.

> Note: Passing all tests in the script does not mean that you will receive a
> perfect score. This script is not guaranteed to test for all bugs, and should
> only be used as a reference for finding mistakes, not for validating that
> there are no mistakes.

## Installation

Run the following in your working directory (the directory you wrote your code
in) to download the latest version of your test script.

```bash
curl https://raw.githubusercontent.com/legendddhgf/CMPS012A-pt.w17-grading-scripts/master/lab4/lab4-check.sh > lab4-check.sh
chmod +x lab4-check.sh
```

If you download it early, there may be updates posted after you have done so.
Please check back near the due date, and run the above line again, to ensure
you have the latest version.

## Usage

After downloading the script, you can run it with the following command:

```bash
./lab4-check.sh
```

The output should be a list of *WARN* and *ERROR* messages. Warnings are for
things that should be fixed, but are not necessarily priority. Errors are
sections that should definitely be fixed, and will result in lost points if not
addressed.

Note that some errors may block others from appearing. An example of this would
be not having a file called Makefile, which obviously means we can't check other
things like whether or not the Makefile compiles. Fixing these errors will allow
us to run more tests, and possibly expose more errors, increasing the overall
error count.

## Removal

Once you are done testing your program, you can delete the script the usual way
with `rm lab4-check.sh`.
