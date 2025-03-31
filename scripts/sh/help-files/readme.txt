If you write only one line under a title, then there is no space between the
title and its content:

Printing a range of lines (e.g., lines 3 to 7):
awk 'NR >= 3 && NR <= 7 { print }' file.txt


If you write several lines under a title, then there is an empty line:

Printing a specific line number (e.g., the 5th line):

awk 'NR == 5 { print }' file.txt
or from stdin:
find /tmp/ssh-XXXXXX* | awk NR==2


If the previous title is multiline, then there are 2 spaces between the next
title and the content of a previous title:

Printing a specific line number (e.g., the 5th line):

awk 'NR == 5 { print }' file.txt
or from stdin:
find /tmp/ssh-XXXXXX* | awk NR==2


Printing a range of lines (e.g., lines 3 to 7):


Otherwise, its 1 emptyline:

Printing a range of lines (e.g., lines 3 to 7):
awk 'NR >= 3 && NR <= 7 { print }' file.txt

Printing the last line:
awk 'END { print }' file.txt
