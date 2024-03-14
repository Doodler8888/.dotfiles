let sshAgentFilePath = $"/tmp/ssh-agent-($env.USER).nuon"

if ($sshAgentFilePath | path exists) and ($"/proc/((open $sshAgentFilePath).SSH_AGENT_PID)" 
        | path exists) {
    load-env (open $sshAgentFilePath)
} else {
    ^ssh-agent -c
        | lines
        | first 2
        | parse "setenv {name} {value};"
        | transpose -r
        | into record
        | save --force $sshAgentFilePath
    load-env (open $sshAgentFilePath)
}

let ssh_key_dir = $env.HOME + "/.ssh/keys"
for key in (ls $ssh_key_dir) {
  if ($key.name != "*.pub" and $key.type == "file") {
    ssh-add $key.name out+err> /dev/null
  }
}


# 'ssh-agent -c' command gives 3 lines. The code takes only the first two.
# ╭───┬────────────────────────────────────────────────────────╮
# │ 0 │ setenv SSH_AUTH_SOCK /tmp/ssh-XXXXXXDTLs4Y/agent.6601; │
# │ 1 │ setenv SSH_AGENT_PID 6603;                             │
# ╰───┴────────────────────────────────────────────────────────╯
# ~   ^ssh-agent -c
# :::          | lines
# :::          | first 2
# :::          | parse "setenv {name} {value};"
# ╭───┬───────────────┬──────────────────────────────────╮
# │ # │     name      │              value               │
# ├───┼───────────────┼──────────────────────────────────┤
# │ 0 │ SSH_AUTH_SOCK │ /tmp/ssh-XXXXXXsmzgl7/agent.6643 │
# │ 1 │ SSH_AGENT_PID │ 6645                             │
# ╰───┴───────────────┴──────────────────────────────────╯
# The 'parse' command seemingly deleted the 'setenv' part. Techically it's
# probably isn't correct to say. The 'set-env' serves as a pattern to match
# against. The purpose of the 'parse' command is to select placeholders which
# are '{name} {value}'. So, in summary, the parse command looking for everything
# that comes after one whitespace character from the 'setenv', the two targets
# are also divided by a whitespace, the last one touching semicolon. Thus there
# is also no semicolon in the output, only characters that matched the
# placeholders. The placeholder names created names for the output columns.
# ~   ^ssh-agent -c
# :::          | lines
# :::          | first 2
# :::          | parse "setenv {name} {value};" 
# :::          | transpose -r
# ╭───┬──────────────────────────────────┬───────────────╮
# │ # │          SSH_AUTH_SOCK           │ SSH_AGENT_PID │
# ├───┼──────────────────────────────────┼───────────────┤
# │ 0 │ /tmp/ssh-XXXXXXFnfI2a/agent.8946 │ 8948          │
# ╰───┴──────────────────────────────────┴───────────────╯
# This is part is quite self explanatory.
# ~     ^ssh-agent -c
# :::         | lines
# :::         | first 2
# :::         | parse "setenv {name} {value};"
# :::         | transpose -r
# :::         | into record
# ╭───────────────┬──────────────────────────────────╮
# │ SSH_AUTH_SOCK │ /tmp/ssh-XXXXXXgc2y3K/agent.9101 │
# │ SSH_AGENT_PID │ 9103                             │
# ╰───────────────┴──────────────────────────────────╯

# $"/proc/((open $sshAgentFilePath).SSH_AGENT_PID)" | path exists The 'open
# $sshAgentFilePath).SSH_AGENT_PID' extracts the 'SSH_AGENT_PID' field value.
# This is the reason for using the 'open' command.
# (open $sshAgentFilePath).SSH_AGENT_PID - i have to enclose the 'open
# $sshAgentFilePath' part because otherwise the 'open' command would try to
# execute itself on 'SHH_AGENT_PID' field and not on the file, which it
# incorrect. The 'load-env' command is able to correctly load the information
# from a storing file, because the information is presented in a compatable
# format, which is the 'record' format.
