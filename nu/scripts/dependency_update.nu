def main [file] {


let latest_dep_versions = open --raw $file
 | lines
 | skip until { |it| $it == '[dependencies]' }
 | skip 1
 | each { split row ' ' | first | echo $in }
 | compact
 | each { cargo search $in | lines | first | split row ' ' | get 2 | str trim --char '"' }


let $current_dep_versions = open --raw $file
 | lines
 | skip until { |it| $it == '[dependencies]' }
 | parse -r '=\s*"([^"]+)"' | values | flatten

mut $index = 0
let $length = ($current_dep_versions | length)

while $index < $length {
  let $current_version = ($current_dep_versions | get $index)
  let $latest_version = ($latest_dep_versions | get $index)

  open --raw $file | str replace ($current_version) ($latest_version) | save -f $file

  $index = $index + 1
}

}



# Urban Gorn, [1/25/24 11:51 AM]
# let input = $in
#     match ($input | describe | str replace --regex '<.*' '') {
#         "string" => { $input ++ $tail },
#         "list" => { $input | each {|el| $el ++ $tail} },
#         _ => $input
#
# Urban Gorn, [1/25/24 8:53 PM]
# I'm not sure you need the regex at all 
# let latest_dep_versions = open Cargo.toml | get dependencies | transpose dep ver | each {|r| upsert ver {cargo search $r.dep | lines | first | split row ' ' | get 2 | str trim --char '"' }}
# let current_dep_versions = open Cargo.toml | get dependencies | transpose dep ver | flatten | each {|r| if (not ($r.version? | is-empty)) { upsert ver $r.version } else {upsert ver $r.ver}} | reject path? version?
# ❯ $latest_dep_versions
# ╭─#─┬─────dep─────┬──ver───╮
# │ 0 │ emojis      │ 0.6.1  │
# │ 1 │ itertools   │ 0.12.0 │
# │ 2 │ nu-plugin   │ 0.89.0 │
# │ 3 │ nu-protocol │ 0.89.0 │
# ╰───┴─────────────┴────────╯
# ❯ $current_dep_versions
# ╭─#─┬─────dep─────┬──ver───╮
# │ 0 │ emojis      │ 0.6.1  │
# │ 1 │ itertools   │ 0.12.0 │
# │ 2 │ nu-plugin   │ 0.89.1 │
# │ 3 │ nu-protocol │ 0.89.1 │
# ╰───┴─────────────┴────────╯
#
# Urban Gorn, [1/25/24 8:54 PM]
# Hi! I'll create a thread so we can read better, is that allright? 😄 
#
# minor suggestion: what do you think about replacing
# let latest_dep_versions = open --raw $file
#  | lines
#  | skip until { |it| $it == '[dependencies]' }
#  | skip 1
#  | each { split row ' ' | first | echo $in }
#  | compact
#  | each { cargo search $in | lines | first | split row ' ' | get 2 | str trim --char '"' }
#
#
# into 
# open Cargo.toml | get dependencies
#
# to get a table? and then select the second column?
