def DO [args?] {
 if $args == null {
   doctl projects list
 } else if $args == 'list' {
   doctl projects list | lines | first 1 | split column -r '\s{2,}' | values | flatten 
 } else if $args == 'p' {
   doctl projects list --format Name,ID
 } else if $args == 'keys' {
   doctl compute ssh-key list
 } else {
   doctl projects list --format $args
 }
}

# The question mark is used to show that the function can be used without a
# parameter. I can also write it like this: '[args?: string]'.

# cmd: 'if (ls -l (fd --type f --hidden . / | fzf) | get user | to text) == "root" {echo "first step"}'

def nvim_fzf [] {
  let fzf_item = (fd --type f --hidden . / --exclude .git --exclude .snapshots
  --exclude var --exclude opt --exclude lib --exclude lib64 --exclude mnt
  --exclude proc --exclude run --exclude sbin --exclude srv --exclude sys
  --exclude tmp | fzf)
  if (ls -l $fzf_item | get user | to text) == "root" {
    sudo -e $fzf_item
    } else if $fzf_item == "" {
      return
    } else {
    nvim $fzf_item
    }
  }

def bak [filename: string] {
 let name = (echo $filename | path basename)
 if (echo $name | str contains '.bak') {
 let new_name = $name | str replace '.bak' ''
 mv $filename $new_name
 } else {
 let new_name = $name + '.bak'
 mv $filename $new_name
 }
}

def gbs [] {
  let branch = (
    git branch |
    split row "\n" |
    str trim |
    where ($it !~ '\*') |
    where ($it != '') |
    str join (char nl) |
    fzf --no-multi
  )
  if $branch != '' {
    git switch $branch
  }
}

def gbd [] {
  let branches = (
    git branch |
    split row "\n" |
    str trim |
    where ($it !~ '\*') |
    where ($it != '') |
    str join (char nl) |
    fzf --multi |
    split row "\n" |
    where ($it != '')
  )
  if ($branches | length) > 0 {
    $branches | each { |branch| git branch -d $branch }
    ""
  }
}

def fzf_zellij [] {
 let session = zellij list-sessions 
  | lines 
  | split column -r '\s+' 
  | get column1 
  | to text 
  | fzf --height=10 --layout=reverse --border --ansi 
 if $session == "" { # Initially i tried to do this 'if ($session | length) != "" {' without return, but it didn't solve the problems with "ambigious selection" input. Also, modifying it to use return also helped me to fix a situation where even if i press escape in the fzf window, a session name still gets used to enter a zellij session.
  return
 }
 zellij attach $session
}


# if (echo $env.SSH_AUTH_SOCK? | describe) == "nothing" {
#   echo "priv"
# }
# ls | where name != 'd1' | each { mv $in.name "./d1" }
# open /etc/passwd | lines | split column ':' | where { ($in.column3 | into int) >= 1000 } | get column1
# 'zellij attach (zellij list-sessions | lines | split column -r '\s+' | get column1 | to text | fzf --ansi)'
# doctl projects list | lines | first 1 | split column -r '\s{2,}' | values | flatten # Or instead of flatten i could transpose this table (or other kinds of strucrutured data) so that i would have only i column with all values using 'transpose -i'.
# ~/test ls -la | where type == 'file' | each { rm $in.name } | null # If i just write 'rm $in', rm would have to perform a deletion using a non-string as an argument, which is incorrect. That's why it is '$in.name'. 'null' in the end makes the command not to make any output like 'empty list' after the pipe is performed.

# $it is just an item (which is a line in this case), where $in represents a list of items.
# rustup show | lines | where $it =~ 'rustc'
# rustup show | lines | where {$in =~ 'rustc'}

# //  [ 4 5 6 ] | each {$in}
# // can be rewritten as:
# > [ 4 5 6 ] | each {}
# ╭───┬───╮
# │ 0 │ 4 │
# │ 1 │ 5 │
# │ 2 │ 6 │
# ╰───┴───╯
