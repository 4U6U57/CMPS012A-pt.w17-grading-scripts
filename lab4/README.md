# cmps012a-pt.w17/lab4

Here's a script to test your lab4. As of right now, it checks comment blocks,
common errors in the Makefile source, and basic Makefile performance (`make` and
`make clean`).

## Installation

> By using this script, you agree to the linked
> [disclaimers](../lib/DISCLAIMER.md).

Run the following in your working directory (the directory you wrote your code
in) to download the latest version of the test script.

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

The output should be a list of **WARN** and **ERROR** messages. Warnings are for
things that should be fixed, but are not necessarily priority. Errors are
sections that should definitely be fixed, and will result in lost points if not
addressed.

Note that some errors may block others from appearing. An example of this would
be not having a file called Makefile, which obviously means we can't check other
things like whether or not the Makefile compiles. Fixing these errors will allow
us to run more tests, and possibly expose more errors, resulting in a larger
error count but overall better code.

## Removal

Once you are done testing your program, you can delete the script the usual way
with `rm lab4-check.sh`. The script also creates a backup of your files on run
in the folder `.backup`, which you can delete with the command `rm -r .backup`.
