# lab6 rubric

lab6 was released on Friday, March 24, 2017. If you submitted the assignment,
you should have received a grade report through your UCSC email with the subject
"[cmps012a-pt.w17] lab6 grade for $USER". Your raw score should also appear on
eCommons.

The average for this assignment was an 18. As always, the lab is out of 20
points, and a detailed breakdown is displayed below. I have included output in
the grade reports which may help indicate what went wrong, if applicable.

## Grade Report

Because it has taken so long to get these back, as well as the fact that finding
all of the errors was difficult, I have opted to include bonus points in my
rubric for following some of the best practices. These bonus points would make
up any points lost in missing errors. Note that your total score for this
assignment shall not exceed the usual maximum of 20 points.

- For each of the program errors
    - (2 points) for describing the error in your `errors` file
    - (1 point) for having at least one test case in your `.dat` files
- Naming of `errors` file
    - (2 points + 2 bonus) for naming it exactly as asked (`errors`)
    - (2 points) for naming it acceptably (`errors.txt`)
    - (1 point) for it not being named right, but existing
- Comment block for `errors` file
    - (1 bonus) for including the filename
    - (1 bonus) for including your first name
    - (1 bonus) for including your CruzID
    - (1 bonus) for putting the assignment name (`lab6`)

For reference, the average student found 4 errors, which I set as the baseline
for figuring out how many bonus points to give. The max score in this situation
(given reasonable expectations) would be (8 points for explanation) + (6 points
for checking all cases) + (4 points for naming the file correctly) + (2 points
for including the standard CruzId + lab6 in a comment).

### Reading the Errors

The errors are specified in regular expression format. Here are some tips for
reading them.

- `\-` means a literal dash
- `\s` means a literal space or tab
- `{char}?` (any character, followed by a question mark) means either 0 or one
    instance of that character.
    - **Example:** `bananas?` would match both *banana* and *bananas*
- `{char}*` (any charcter, followed by an asterisk) means 0 or more instances of
    that character
    - **Example:** `sneks*` would match *sneks*, *snekss*, and *sneksssss*, and
        *snek*

- `{char}+` (any character, followed by a +) means either 1 or more instances of
    that character
    - **Example:** `sneks+` would match *sneks*, *snekss*, and *sneksssss*, but
        not *snek*
- `({pattern})` Parentheses enclose a pattern, which can substitute for a
    character in the above two rules
    - **Example:** `(Oo)+H` would match *OoH*, *OoOoOoH*, and *OoOoOoOoOoOoH*
- `[{char}-{char}]` specifies one character in a range
    - **Example:** `[0-2]` would match *0*, *1*, or *2*
    - **Example:** `[1-9][0-9]` would match any number from *10* to *99*
- `({pattern}|{pattern})` matches either pattern
    - **Example:** `([5-9]|[1-9][0-9])` matches any number from *5* to *99*

That being said, here are some practical examples:
- `2\s+3` would mean the input *2 3* (or that input with any number of spaces
    in between, which is allowed in the program)
- `5\s+[1-4]` would match the sentence code *5* with any modifier from *1* to
    *4*
- The set of inputs which result in the (invalid sentence code) error would be
    described as `-?(0|[6-9]|[1-9][0-9]+)\s\-?[0-9]+` (an optional minus sign,
    followed by either 0, any number from 6-9, or any number larger than 10,
    followed by a space, followed by any number possibly negative)

## Questions/Concerns

If you have any generic questions about this rubric, please post it in the
follow up discussion below. For any specific questions (based on your
submission), please follow the directions in your grade report email. I will
only address specific questions that are sent as a reply to your original grade
report email (only exception: if you did not receive one and think you should
have). This is to give me context as to what you are referring to, and your
specific submission information. The last day I will be accepting emails is
midnight, end of Sunday, March 26th.
