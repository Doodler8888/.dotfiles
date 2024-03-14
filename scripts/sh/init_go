#!/bin/bash

echo -e "\nEnter path for the project:\n"
echo "1 - Enter a path"
echo "2 - Skip and move to the next stage"
printf "\n=> "
read -r choice # By default, read interprets the backslash as an escape character, which sometimes may cause unexpected behavior. To disable backslash escaping, invoke the command with the -r option.

case $choice in
    1)
        printf "\nEnter a path:\n\n"
        printf "=> "
        read -r project_path
	project_path="${project_path/#~/$HOME}" # Expanding the tilde to the home directory manually in Bash
        mkdir -p "$project_path"
        ;;
    2)
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

text="\nThe module path is a unique identifier for your module. It's used to
import packages from your module in other Go programs. It can be a path to a
local or remote repository:

> go mod init my_project\n"

echo -e "$text"

printf "Enter module path:\n"
printf "\n=> "
read -r module_path && printf "\n"

cd "$project_path" && go mod init "$module_path" && printf "\n"

printf "\nPost installation:\n\n"
printf "1 - How the go's import system work\n"
printf "\nPress any other key to exit\n"
printf "\n=> "
read -r choice

case $choice in
    1)
       printf "
       To import a package you need to specify path to a package directory,
       not to a specific file. An imported code is used likes this:

       import (
	\"example.com/user/project/pkg/time\"
       )

       time.'item name'

       But without looking at the package source, you might assume the package name
       is time, but it could be defined as package timelib within the package.
       Go's approach allows the package to be imported and used explicitly,
       avoiding confusion and potential conflicts with Go's standard library
       time package:

       import (
   	myTime \"example.com/user/project/pkg/time\"
       )
   
       Then just use the alias to access the package's items.\n\n"
       ;;
   *)
       exit 1
       ;;
esac
