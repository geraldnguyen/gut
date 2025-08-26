# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2025-01-27

### Added
- Initial release of gut - A simple wrapper around "git" for when users mis-type "gut" instead of "git"

### Original Prompt

The following is the original prompt that led to the creation of this project:

---

Create a simple command line executable call "gut" that can run on multiple platform such as windows, macos, linux.

Gut is a simple wrapper around "git", to run when user mis-typed "gut" instead of "git"

Please prepare a simple documentation e.g. README, INSTALL for the project.

*   **Language**: Go
*   **Behavior**: Print a witty random quote about mis-typing, then forward all arguments to `git`
*   **Error handling**: Direct users to install git if not found
*   **Build tools**: Makefile for cross-platform compilation
*   **Documentation**: Complete README with installation for all platforms
*   **Version**: Starting at 1.0.0
*   **CHANGELOG**: Captures original prompt and clarifications

Capture this prompt verbatim in a CHANGELOG file.

---

### Features Implemented
- Cross-platform command line executable (Windows, macOS, Linux)
- Random witty quotes about mistyping "gut" instead of "git"
- Forwards all arguments to the actual `git` command
- Error handling with helpful installation instructions when git is not found
- Makefile for cross-platform compilation (supports amd64 and arm64 architectures)
- Complete documentation (README, INSTALL)
- Version 1.0.0 as requested