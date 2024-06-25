import subprocess

# Run the command and capture the output
result = subprocess.run("zellij list-sessions | awk '($1 ~ /-/) {print $1}'",
shell=True, capture_output=True, text=True)

# Split the output into lines
names = result.stdout.strip().split('\n')

# Iterate over the elements of the names list
for name in names:
    print(f"This is a session name: {name}")


# 'shell=True' used because i need to use the pipe operator. It says to use my
# default shell.

# 'capture_output=True' - i don't need to always capture output. Sometimes i
# just need to execute a command. So it makes total sense that i need to specify
# it.

# By using 'text=True' i instruct to decode the output of raw bytes using UTF-8.
