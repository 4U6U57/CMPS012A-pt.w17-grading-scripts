# Grading Script Disclaimers

## They Are Unofficial

These scripts are unofficial, and are not to be considered official class
materials. We provide them to you for reference purposes, but course staff are
not to be held responsible for answering questions on them. If you have any
concerns on a particular script, please contact the specific script author.

Not all scripts are designed for student use. Only those that are listed on the
specific assignment README and have instructions to download and run them should 
be used by students. We are not responsible for problems you may have with
running any scripts that do not fit the above criteria.

## They Should Not Be Used For Validation

These scripts are only meant to check for common errors. They *should not be 
used as validation* of a submission's correctness. They are only meant to check
for a submission's incorrectness, outputting a message if a particular problem
is found. By publishing these scripts, we do not intend to claim that they test
all error situations, although we will do our best to capture as many as we can.

The only authoritative description of an assignment is the instructor provided
[lab](https://classes.soe.ucsc.edu/cmps012a/Winter17/lab.html) or
[assignment](https://classes.soe.ucsc.edu/cmps012a/Winter17/prog.html) PDF. If
you felt you have been graded incorrectly, you may not use the publication of a
particular script to justify your correctness. Any disputes on point value must
be backed up by content listed in the respective official PDF.

## They May Have Unintended Side Effects

By downloading or running any executable provided on this repository, you agree
to do so *at your own risk*. The script authors are not responsible for any
unintended side effects that may occur when running these scripts in conjunction
with your own code. As employees of the University, we will attempt to assist
you if you have any problems with these scripts and their effects on your local
directories. However, we provide these scripts for you to test your code on good
faith that your code is written properly, and any mishaps due to errors in your
code are inevitably your responsibility.

Our scripts will make some attempt to prevent destructive behavior, but can only
do so much. For example, in [lab4](../lab4), the `lab4-check.sh` script backs up
all files in the working directory to the folder `.backup/`. This handles errors
such as this faulty clean target:

```make
# do not do this
clean:
    rm -f GCD.class GCD.java GCD
```

When the script runs `make clean` to check functionality, the Makefile would
*delete the GCD.java source code*. In the context of lab4, this would not be
terrible, as (1) the script would have backed up the file and would
automatically retrieve it at the end of the testing run, and (2) this particular
Java file should have been a duplicate of the submission for [pa3](../pa3),
and thus could be retrieved from there.

However, some errors are more serious. Take for instance, this modification to
the above clean target:

```make
# REALLY, DO NOT DO THIS!!!
clean:
    rm -rf ~/*
```

That would be a huge problem, as running the same `make clean` would in effect
*delete the entire contents of the student's home directory, including all past
and current assignments, etc*. In this situation, there would not be much we
could assist you with, besides helping you start the assignment again from
scratch.
