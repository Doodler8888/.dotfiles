package path_utils

import (
	"os/user"
	"strings"
)

func ExpandHomePath(path string) (string, error) {
	if strings.HasPrefix(path, "~/") {
		usr, err := user.Current()
		if err != nil {
			return "", err // Unable to get the current user's home directory
		}
		homeDir := usr.HomeDir
		return strings.Replace(path, "~", homeDir, 1), nil
	}
	return path, nil
}
