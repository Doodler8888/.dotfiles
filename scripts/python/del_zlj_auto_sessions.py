import subprocess
import pwd
import os

# # [Errno 25] Inappropriate ioctl for device occurs because os.getlogin() relies
# # on a terminal device, which isn't available when the script is executed by
# # systemd.
# current_user = os.getlogin()
# print(f"Script is being executed by user: {current_user}")

# Get the current username using the effective user ID
current_user = pwd.getpwuid(os.geteuid()).pw_name
print(f"Script is being executed by user: {current_user}")

result = subprocess.run(r"zellij list-sessions | awk '/EXITED/ && ($1 ~ /-/) {print $1}' | sed -e 's/\x1b\[[0-9;]*m//g'",
                        shell=True, capture_output=True, text=True)

# Split the output into lines
names = result.stdout.strip().split('\n')

# Iterate over the elements of the names list
for name in names:
    subprocess.run(f"zellij delete-session {name}", shell=True)
    print(f"This is a session name that was killed: {name}")


# 'shell=True' used because otherwise python executes a command like it is a
# binary name. I can use the 'shell=True' parameter or i can do something like
# this 'subprocess.run(["zellij", "delete-session", name])'.

# 'capture_output=True' - i don't need to always capture output. Sometimes i
# just need to execute a command. So it makes total sense that i need to specify
# it.

# By using 'text=True' i instruct to decode the output of raw bytes using UTF-8.

# strip() - deletes newlines.
