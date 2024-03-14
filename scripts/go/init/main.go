package main

import (
	initGo "github.com/Doodler8888/.dotfiles/scripts/go/init/pkg/go"
	// "./postgres"
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Please specify a subcommand")
		os.Exit(1)
	}

	switch os.Args[1] {
	case "go":
		initGo.Init()
	// case "postgres":
	// 	postgres.Init()
	default:
		fmt.Printf("%q is not a known subcommand.\n", os.Args[1])
		os.Exit(1)
	}
}


// The switch statement is a control structure used to simplify multiple if -
// else if - else chains. It evaluates an expression and then searches for a
// case clause matching the expression's value.
// The default clause in a switch statement is optional and serves as a fallback
// if no case matches the expression's value. It's akin to the else in an if -
// else if - else chain.
