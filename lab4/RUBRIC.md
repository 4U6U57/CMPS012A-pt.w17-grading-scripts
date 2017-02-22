# lab4 rubric

lab4 was released on Wednesday, February 21, 2017. If you submitted the
assignment, you should have received a grade report through your UCSC email with
the subject "[cmps012a-pt.w17] lab4 grade for $USER". Your raw score should also
appear on eCommons.

The average for this assignment was an 18. As always, the lab is out of 20
points, and a detailed breakdown is displayed below. I have included output in
the grade reports which may help indicate what went wrong, if applicable.

## Grade Report

- For each of `{Makefile, GCD.java}` (8 points)
    - (2 points) for the file existing
    - (2 points) for being named properly (Incorrect examples: `{MakeFile,
        makefile, gcd.java, GDC.java}`)
    - *No penalty for submitting extra files, because they can't be deleted*
- Makefile Comment block ((4 points)**
    - (2 points) for comment block existing (there is at least a single line
        that starts with # in the first 10 lines of the file)
    - (1 point) for the comment block containing your CruzID (run `echo $USER`
        to find out what this is)
    - (1 point) for the comment block containing the assignment name (lab4)
    - *If you did not submit a Makefile, you were not penalized for the above*
- Makefile common errors - white box testing (2 points)
    - (1 point) for changing the submit target to the right assignment (lab1
        -> lab4)
    - (1 point) for changing the executable name (HelloWorld -> GCD)
    - *If you did not submit a Makefile, you were not penalized for the above*
    - *If you submitted an incorrectly named `.java` file, you were tested on
        taking that into consideration*
- Makefile performance - black box testing (4 points)
    - (1 point) for `make` creating executable with executable bit `+x` set
    - For each of `{GCD.class, GCD, Manifest}`
        - (1 point) for `make clean` deleting this generated file
    - *If you submitted an incorrectly named `.java` file, you were tested on
        taking that into consideration*
    - *If you did not submit a `.java` file, a placeholder file (specifically,
        the HelloWorld example from lab1) was copied into your folder as
        `GCD.java` to test `make`*
    - *If your `make` command did not run correctly, placeholder files (really
        just text files) were copied into your folder to test `make clean`*
- Submission safety, for each of `{Makefile, GCD.java}` (2 points)
    - (1 point) for not deleting/modifying the file

## Questions/Concerns

If you have any generic questions about this rubric, please post it in the
follow up discussion below. For any specific questions (based on your
submission), please follow the directions in your grade report email. I will
only address specific questions that are sent as a reply to your original grade
report email (only exception: if you did not receive one and think you should
have). This is to give me context as to what you are referring to, and your
specific submission information.
