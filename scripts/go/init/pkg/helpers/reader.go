package helper

import (
	"bufio"
	"strings"
)

// readTrimmedLine reads a line from stdin and trims the whitespace.
func ReadTrimmedLine(reader *bufio.Reader) (string, error) {
	input, err := reader.ReadString('\n')
	if err != nil {
		return "", err // Return the error to the caller
	}
	return strings.TrimSpace(input), nil
}
