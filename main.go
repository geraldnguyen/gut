package main

import (
	"fmt"
	"math/rand"
	"os"
	"os/exec"
	"time"
)

const version = "1.0.0"

// wittyQuotes contains humorous messages about mistyping "gut" instead of "git"
var wittyQuotes = []string{
	"🤔 I see you typed 'gut' instead of 'git'. Don't worry, happens to the best of us!",
	"😄 'gut' feeling tells me you meant 'git'! Let me fix that for you...",
	"🎯 Close! You typed 'gut' but I think you meant 'git'. Forwarding your command...",
	"😅 Trust your gut... I mean git! Redirecting your 'gut' command to 'git'.",
	"🔧 Gut instinct: you probably meant 'git'. Running the correct command now!",
	"💡 'gut' reaction: this should be 'git'! No worries, I've got you covered.",
	"🚀 From 'gut' to 'git' in 0.1 seconds! Here we go...",
	"😊 Typo detected! Transforming 'gut' into 'git' like magic.",
	"🎪 Welcome to the 'gut' to 'git' translation service! Your command is being processed.",
	"🤓 Fun fact: 'gut' backwards is 'tug', but you probably want 'git'!",
}

func main() {
	// Seed the random number generator
	rand.Seed(time.Now().UnixNano())

	// Print a random witty quote
	quote := wittyQuotes[rand.Intn(len(wittyQuotes))]
	fmt.Println(quote)
	fmt.Println()

	// Check if git is available
	gitPath, err := exec.LookPath("git")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: git is not installed or not found in PATH.\n")
		fmt.Fprintf(os.Stderr, "Please install git first:\n")
		fmt.Fprintf(os.Stderr, "  - Windows: Download from https://git-scm.com/download/win\n")
		fmt.Fprintf(os.Stderr, "  - macOS: brew install git or download from https://git-scm.com/download/mac\n")
		fmt.Fprintf(os.Stderr, "  - Linux: apt install git / yum install git / pacman -S git\n")
		os.Exit(1)
	}

	// Forward all arguments to git
	cmd := exec.Command(gitPath, os.Args[1:]...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin

	// Execute the git command
	err = cmd.Run()
	if err != nil {
		if exitError, ok := err.(*exec.ExitError); ok {
			os.Exit(exitError.ExitCode())
		}
		fmt.Fprintf(os.Stderr, "Error executing git: %v\n", err)
		os.Exit(1)
	}
}