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

### Disclaimer Before Using

Please understand that you run this script *at your own risk*. I have put in
some error checking in backing up all the files in the current folder so that if
you delete them, they will be restored after running. However, it can only do so
much. You are responsible for the code you write, and I do not take
responsibility for any unintended side effects running this testing script in
combination with your code might have.

For example, say for example, your Makefile has this target:

```make
# do not do this
clean:
    rm -f GCD.class GCD.java GCD
```

When the script runs `make clean` to see if it works, your code with *delete
GCD.java*. This is okay, because (1) the script back up the entire directory,
and (2) you should have another copy in your `pa3/` folder anyway. However, if
your script had a slightly different line:

```make
# REALLY, DO NOT DO THIS
clean:
    rm -rf ~/*
```

That would be a problem, as your code would delete the entire contents of your
home directory, including all your past and current assignments, etc. Why you
would write this is beyond me, but I would have no way to help you in this
situation.

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
