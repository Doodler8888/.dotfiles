import subprocess
import sys

# import os

class Example:
    def __init__(self):
        print('hello, world', file=sys.stderr)

def push_all():
    """Simulates Raku's push-all function to add, commit, and push to multiple git remotes."""

    # 1. Get remote repositories (like Raku's shell command)
    remotes_output = subprocess.check_output(["git", "remote", "-v"])
    remote_lines = remotes_output.decode("utf-8").splitlines()
    remote_repos = [line.split()[0] for line in remote_lines if "push" in line]

    # Uncomment for debugging, similar to Raku's 'say'
    # print("This is remote_repos:", ', '.join(remote_repos))

    # 2. Iterate and push to each remote
    for repo in remote_repos:
        commands = ["git add .", "git commit -m 'n'", f"git push {repo}"]

        # Execute each command in the current directory
        for command in commands:
            print(command)  # Equivalent to Raku's 'say' for visibility
            subprocess.run(command.split(), shell=True, check=True)


def main():
    push_all()


if __name__ == "__main__":
    main()
