#!/usr/bin/nu

let text = "\nThe module path is a unique identifier for your module. It's used to
import packages from your module in other Go programs. It can be a path to a
local or remote repository, but you can use an actual path format for a local repository:

> go mod init my_project\n"

print -n "\nEnter path for the project:\n
1 - Enter a path
2 - Skip and move to the next stage\n\n"

input "=> " | match $in {
    "1" => { 
	print "\nEnter a path:\n" 
	let project_path = (input "=> ") | path expand
	mkdir $project_path
	print $text
	print "\nEnter module path:"
	input "=> " | { |it| 
	cd $project_path; ^go mod init $it
	 }
	}
    "2" => { print "You've pressed 2" }
     _ => { echo "Invalid choice" }
}
