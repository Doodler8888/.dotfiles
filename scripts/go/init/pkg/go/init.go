package init_go

import (
	"bufio"
	"fmt"
	"github.com/Doodler8888/.dotfiles/scripts/go/init/pkg/helpers"
	"github.com/Doodler8888/.dotfiles/scripts/go/init/pkg/path_utils"
	"os"
	"os/exec"
	"strings"
)

func Init() {
	reader := bufio.NewReader(os.Stdin)

	fmt.Print(
		"\nEnter path for the project:\n\n",
		"1 - Enter a path\n",
		"2 - Skip and move to the next stage\n\n",
		"=> ")

	choice, _ := helper.ReadTrimmedLine(reader)

	var projectPath string // It's declared for reuse.
	var err error

	switch choice {
	case "1":
		fmt.Print("\nEnter the project path: ")
		projectPath, _ = helper.ReadTrimmedLine(reader)
		projectPath, err = path_utils.ExpandHomePath(projectPath)
		if err != nil {
			fmt.Printf("Error expanding path: %v\n", err)
			return
		}
		fmt.Println("\nProject path set to:", projectPath)
		// Attempt to create the directory if it doesn't exist
		err = os.MkdirAll(projectPath, 0755) // os.ModePerm is 0777, allowing read, write, and execute
		if err != nil {
			fmt.Printf("Error creating directory: %v\n", err)
			return
		}

	case "2":
		fmt.Println("Skipping project path input.")
	default:
		fmt.Println("Invalid choice.")
		return
	}

	fmt.Println(ModulePathMessage)
	fmt.Print("\n" + "Enter module path: ")
	modulePath, _ := reader.ReadString('\n')
	modulePath = strings.TrimSpace(modulePath) // Remove newline character

	cmd := exec.Command("go", "mod", "init", modulePath)
	cmd.Dir = projectPath
	cmd.Stdout = os.Stdout // to display the output of the command
	cmd.Stderr = os.Stderr // to display any error
	err = cmd.Run()
	if err != nil {
		fmt.Printf("Error initializing module: %s\n", err)
		return
	}

	fmt.Print("Module initialized successfully.\n\n")
}

// In the context of your usage, where you're including a lengthy explanation
// that spans multiple lines and you want to preserve the formatting exactly as
// it is (including newlines and potentially spaces at the beginning of lines),
// backticks are the natural choice. They allow you to write the string in a way
// that mirrors how you want it to appear when printed, without cluttering the
// text with escape sequences for newlines.

// The bufio.NewReader(os.Stdin) to read input from the standard input
// (os.Stdin) until it encounters a newline character ('\n'). The ReadString
// method reads the input byte by byte until it finds the specified delimiter
// ('\n' in this case), and then it returns the string up to (and including)
// that delimiter. The returned string is assigned to the variable modulePath.

// The reader doesn't take an argument without a delimiter, so i have to specify
// something. Newline is correct choice here.

// The strings.TrimSpace function in Go is used to remove leading and trailing
// whitespace from a string. This includes spaces, tabs, newlines, and other
// Unicode whitespace characters.

// The Cmd struct has Stdout and Stderr fields among others, which you can set
// to direct the standard output and standard error streams of the command.
// If you do not explicitly set cmd.Stdout, the command's standard output will
// not automatically be displayed in the terminal where your Go program is
// running. Instead, the output will be captured by your Go program.

// When you call exec.Command, you're not actually executing the command at that
// moment. Instead, you're creating a *exec.Cmd struct that represents an
// external command to be executed later.
// The cmd.Run() method is what actually starts the external command and waits
// for it to finish.
