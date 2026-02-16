---
title: Mac Terminal Cheatsheet
sidebar_position: 1
displayed_sidebar: technologySidebar
tags:
  - mac
  - terminal
  - commands
  - macos
description: Essential Mac terminal commands for navigation, file operations, networking, and system management — from beginner to power user.
---

# Mac Terminal Cheatsheet

Your friendly guide to mastering the Mac Terminal — because sometimes clicking is just too slow! 🚀

> **What is Terminal?** Terminal is macOS's command-line interface (CLI) that lets you control your Mac using text commands instead of clicking — faster, scriptable, and more powerful.

---

## 🧭 Navigation Basics

**Getting around your file system is like navigating a building.** Your Mac's files are organized in folders (directories), and the terminal lets you walk through them using text commands instead of clicking. Think of `pwd` as asking "Where am I?", `ls` as "What's in this room?", and `cd` as "Take me to...".

| Command | What It Does | Example |
|---------|--------------|---------|
| `pwd` | Print Working Directory — shows your current location | `pwd` → `/Users/john/Documents` |
| `ls` | List contents of current directory | `ls` |
| `ls -la` | List ALL files (including hidden) with details | `ls -la` |
| `ls -lh` | List with human-readable file sizes | `ls -lh` |
| `cd <folder>` | Change Directory — move into a folder | `cd Documents` |
| `cd ..` | Go up one level (parent folder) | `cd ..` |
| `cd ~` | Go to your home directory | `cd ~` |
| `cd -` | Go back to previous directory | `cd -` |
| `cd /` | Go to root directory | `cd /` |

> 💡 **Pro Tip:** Press `Tab` to auto-complete folder and file names — saves tons of typing!

---

## 📁 File & Folder Operations

**Creating, copying, moving, and deleting files is the bread and butter of terminal work.** These commands are faster than drag-and-drop once you get the hang of them. Just remember: the terminal doesn't have a trash can — when you `rm` something, it's gone for good!

| Command | What It Does | Example |
|---------|--------------|---------|
| `mkdir <name>` | Make Directory — create a new folder | `mkdir projects` |
| `mkdir -p a/b/c` | Create nested folders in one go | `mkdir -p src/components/ui` |
| `touch <file>` | Create an empty file (or update timestamp) | `touch notes.txt` |
| `cp <src> <dest>` | Copy a file | `cp file.txt backup.txt` |
| `cp -r <src> <dest>` | Copy a folder and all its contents | `cp -r folder1 folder2` |
| `mv <src> <dest>` | Move or rename a file/folder | `mv old.txt new.txt` |
| `rm <file>` | Remove (delete) a file — no undo! | `rm unwanted.txt` |
| `rm -r <folder>` | Remove a folder and everything inside | `rm -r old_project` |
| `rm -rf <folder>` | Force remove without confirmation | `rm -rf node_modules` |
| `rmdir <folder>` | Remove an empty folder only | `rmdir empty_folder` |

> ⚠️ **Warning:** `rm -rf` is powerful and dangerous. Double-check your path before hitting Enter!

---

## 👀 Viewing File Contents

**Sometimes you just need a quick peek inside a file without opening an editor.** These commands let you view file contents right in the terminal. Use `cat` for small files, `less` for scrolling through big ones, and `head`/`tail` when you only need the beginning or end.

| Command | What It Does | Example |
|---------|--------------|---------|
| `cat <file>` | Display entire file contents | `cat readme.md` |
| `less <file>` | View file with scrolling (press `q` to quit) | `less long_log.txt` |
| `more <file>` | Similar to less, but simpler | `more file.txt` |
| `head <file>` | Show first 10 lines | `head log.txt` |
| `head -n 20 <file>` | Show first 20 lines | `head -n 20 log.txt` |
| `tail <file>` | Show last 10 lines | `tail log.txt` |
| `tail -n 50 <file>` | Show last 50 lines | `tail -n 50 log.txt` |
| `tail -f <file>` | Follow file in real-time (great for logs!) | `tail -f server.log` |
| `wc <file>` | Word count — lines, words, characters | `wc essay.txt` |
| `wc -l <file>` | Count lines only | `wc -l data.csv` |

> 💡 **Pro Tip:** `tail -f` is perfect for watching log files update live while debugging!

---

## 🔍 Finding Things

**Lost a file? Need to find text inside files?** These search commands are your detective tools. `find` searches by file name and location, while `grep` searches inside files for specific text. Combine them for powerful searches across your entire system.

| Command | What It Does | Example |
|---------|--------------|---------|
| `find <path> -name "<pattern>"` | Find files by name | `find . -name "*.txt"` |
| `find . -type f` | Find files only (not folders) | `find . -type f` |
| `find . -type d` | Find directories only | `find . -type d` |
| `find . -mtime -7` | Files modified in last 7 days | `find . -mtime -7` |
| `find . -size +100M` | Files larger than 100MB | `find . -size +100M` |
| `grep "<text>" <file>` | Search for text in a file | `grep "error" log.txt` |
| `grep -r "<text>" <dir>` | Search recursively in directory | `grep -r "TODO" src/` |
| `grep -i "<text>" <file>` | Case-insensitive search | `grep -i "hello" file.txt` |
| `grep -n "<text>" <file>` | Show line numbers | `grep -n "function" app.js` |
| `grep -c "<text>" <file>` | Count matching lines | `grep -c "error" log.txt` |
| `mdfind "<query>"` | Spotlight search from terminal | `mdfind "budget 2024"` |
| `which <command>` | Find where a command lives | `which python` |

> 💡 **Pro Tip:** Use `grep -rn "search" .` to search all files and show line numbers — super handy!

---

## ✏️ Text Editing in Terminal

**Need to edit a file without leaving the terminal?** These built-in editors work right in your terminal window. `nano` is beginner-friendly with on-screen help, while `vim` is powerful but has a learning curve. For quick edits, `nano` is your friend!

| Command | What It Does | Example |
|---------|--------------|---------|
| `nano <file>` | Open file in Nano editor (beginner-friendly) | `nano config.txt` |
| `vim <file>` | Open file in Vim editor (powerful but tricky) | `vim script.sh` |
| `vi <file>` | Same as vim on Mac | `vi file.txt` |
| `open <file>` | Open file with default Mac app | `open photo.jpg` |
| `open -a "App" <file>` | Open with specific app | `open -a "VS Code" .` |
| `open .` | Open current folder in Finder | `open .` |
| `pbcopy` | Copy input to clipboard | `cat file.txt \| pbcopy` |
| `pbpaste` | Paste from clipboard | `pbpaste > newfile.txt` |

**Nano Quick Reference:**
- `Ctrl + O` → Save file
- `Ctrl + X` → Exit
- `Ctrl + K` → Cut line
- `Ctrl + U` → Paste line

**Vim Quick Reference (if you accidentally open it!):**
- Press `i` → Enter insert mode (to type)
- Press `Esc` → Exit insert mode
- Type `:wq` → Save and quit
- Type `:q!` → Quit without saving

---

## 📊 Disk & Storage

**Running out of space? Need to know how big a folder is?** These commands help you understand what's eating up your disk. `df` shows overall disk usage, while `du` digs into specific folders. Perfect for hunting down those mystery files hogging your storage!

| Command | What It Does | Example |
|---------|--------------|---------|
| `df -h` | Show disk space usage (human-readable) | `df -h` |
| `du -sh <folder>` | Show folder size | `du -sh ~/Downloads` |
| `du -sh *` | Show size of all items in current dir | `du -sh *` |
| `du -h -d 1` | Show sizes one level deep | `du -h -d 1` |
| `diskutil list` | List all disks and partitions | `diskutil list` |
| `diskutil info <disk>` | Show disk information | `diskutil info disk0` |

> 💡 **Pro Tip:** `du -sh * | sort -h` sorts folders by size — great for finding space hogs!

---

## 🔐 Permissions & Ownership

**Every file has rules about who can read, write, or run it.** Permissions are like locks on doors — they control access. When you see "Permission denied", you might need `sudo` (superuser do) to override, or `chmod` to change the rules.

| Command | What It Does | Example |
|---------|--------------|---------|
| `chmod +x <file>` | Make file executable | `chmod +x script.sh` |
| `chmod 755 <file>` | rwx for owner, rx for others | `chmod 755 app` |
| `chmod 644 <file>` | rw for owner, r for others | `chmod 644 config.txt` |
| `chown <user> <file>` | Change file owner | `chown john file.txt` |
| `chown -R <user> <dir>` | Change owner recursively | `chown -R john project/` |
| `sudo <command>` | Run as superuser (admin) | `sudo rm protected.txt` |
| `sudo !!` | Re-run last command as sudo | `sudo !!` |

**Permission Numbers Explained:**
- `7` = read + write + execute (rwx)
- `6` = read + write (rw-)
- `5` = read + execute (r-x)
- `4` = read only (r--)
- `0` = no permissions (---)

---

## 🌐 Networking

**Curious about your network connection or need to download something?** These commands let you check connectivity, download files, and troubleshoot network issues — all without opening a browser.

| Command | What It Does | Example |
|---------|--------------|---------|
| `ping <host>` | Test connection to a server | `ping google.com` |
| `curl <url>` | Download content from URL | `curl https://api.example.com` |
| `curl -O <url>` | Download and save file | `curl -O https://example.com/file.zip` |
| `wget <url>` | Download file (if installed) | `wget https://example.com/file.zip` |
| `ifconfig` | Show network interfaces | `ifconfig` |
| `ipconfig getifaddr en0` | Get your local IP address | `ipconfig getifaddr en0` |
| `networksetup -getinfo Wi-Fi` | Get Wi-Fi network info | `networksetup -getinfo Wi-Fi` |
| `lsof -i :<port>` | Find what's using a port | `lsof -i :3000` |
| `netstat -an` | Show all network connections | `netstat -an` |
| `traceroute <host>` | Trace route to host | `traceroute google.com` |
| `nslookup <domain>` | DNS lookup | `nslookup github.com` |
| `ssh <user>@<host>` | Connect to remote server | `ssh john@192.168.1.100` |
| `scp <file> <user>@<host>:<path>` | Copy file to remote server | `scp file.txt john@server:/home/` |

> 💡 **Pro Tip:** Use `curl -I <url>` to see just the headers — quick way to check if a site is up!

---

## ⚙️ Process Management

**Programs running on your Mac are called processes.** Sometimes apps freeze or hog resources. These commands let you see what's running, find resource hogs, and kill misbehaving programs — like Task Manager, but cooler!

| Command | What It Does | Example |
|---------|--------------|---------|
| `ps aux` | List all running processes | `ps aux` |
| `ps aux \| grep <name>` | Find specific process | `ps aux \| grep chrome` |
| `top` | Live view of processes (press `q` to quit) | `top` |
| `htop` | Better top (if installed) | `htop` |
| `kill <PID>` | Terminate process by ID | `kill 1234` |
| `kill -9 <PID>` | Force kill process | `kill -9 1234` |
| `killall <name>` | Kill all processes by name | `killall Safari` |
| `pkill <pattern>` | Kill processes matching pattern | `pkill -f "node server"` |
| `Activity Monitor` (GUI) | Open via: `open -a "Activity Monitor"` | |

> 💡 **Pro Tip:** In `top`, press `o` then type `cpu` to sort by CPU usage, or `mem` for memory!

---

## 📦 Package Management (Homebrew)

**Homebrew is like an app store for your terminal.** It makes installing command-line tools and apps incredibly easy — no more hunting for downloads or dealing with installers. If you don't have it, install it first!

```bash
# Install Homebrew (one-time setup)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

| Command | What It Does | Example |
|---------|--------------|---------|
| `brew install <package>` | Install a package | `brew install git` |
| `brew uninstall <package>` | Remove a package | `brew uninstall node` |
| `brew update` | Update Homebrew itself | `brew update` |
| `brew upgrade` | Upgrade all packages | `brew upgrade` |
| `brew upgrade <package>` | Upgrade specific package | `brew upgrade python` |
| `brew list` | List installed packages | `brew list` |
| `brew search <name>` | Search for packages | `brew search postgres` |
| `brew info <package>` | Get package information | `brew info node` |
| `brew doctor` | Check for problems | `brew doctor` |
| `brew cleanup` | Remove old versions | `brew cleanup` |
| `brew services list` | List background services | `brew services list` |
| `brew services start <svc>` | Start a service | `brew services start postgresql` |
| `brew services stop <svc>` | Stop a service | `brew services stop postgresql` |
| `brew install --cask <app>` | Install GUI app | `brew install --cask visual-studio-code` |

---

## 🔧 System Information

**Want to know more about your Mac?** These commands reveal system details like macOS version, hardware specs, and uptime. Handy for troubleshooting or just satisfying your curiosity!

| Command | What It Does | Example |
|---------|--------------|---------|
| `sw_vers` | Show macOS version | `sw_vers` |
| `uname -a` | System information | `uname -a` |
| `hostname` | Show computer name | `hostname` |
| `whoami` | Show current username | `whoami` |
| `id` | Show user and group IDs | `id` |
| `uptime` | How long system has been running | `uptime` |
| `date` | Current date and time | `date` |
| `cal` | Show calendar | `cal` |
| `system_profiler SPHardwareDataType` | Hardware overview | `system_profiler SPHardwareDataType` |
| `sysctl -n machdep.cpu.brand_string` | CPU model | `sysctl -n machdep.cpu.brand_string` |
| `top -l 1 \| head -n 10` | Quick system stats | `top -l 1 \| head -n 10` |

---

## 🎯 Handy Shortcuts & Tricks

**These tricks will make you feel like a terminal wizard!** From keyboard shortcuts to command chaining, these tips speed up your workflow dramatically.

### Keyboard Shortcuts

| Shortcut | What It Does |
|----------|--------------|
| `Ctrl + C` | Cancel current command |
| `Ctrl + Z` | Suspend current process |
| `Ctrl + D` | Logout / Exit shell |
| `Ctrl + L` | Clear screen (same as `clear`) |
| `Ctrl + A` | Move cursor to beginning of line |
| `Ctrl + E` | Move cursor to end of line |
| `Ctrl + U` | Delete from cursor to beginning |
| `Ctrl + K` | Delete from cursor to end |
| `Ctrl + W` | Delete word before cursor |
| `Ctrl + R` | Search command history |
| `Tab` | Auto-complete file/folder names |
| `Tab Tab` | Show all auto-complete options |
| `↑ / ↓` | Navigate command history |
| `!!` | Repeat last command |
| `!$` | Last argument of previous command |

### Command Chaining

| Pattern | What It Does | Example |
|---------|--------------|---------|
| `cmd1 && cmd2` | Run cmd2 only if cmd1 succeeds | `npm install && npm start` |
| `cmd1 \|\| cmd2` | Run cmd2 only if cmd1 fails | `test -f file \|\| touch file` |
| `cmd1 ; cmd2` | Run both regardless of success | `echo "Hi" ; echo "Bye"` |
| `cmd1 \| cmd2` | Pipe output of cmd1 to cmd2 | `cat file.txt \| grep "error"` |
| `cmd > file` | Redirect output to file (overwrite) | `ls > files.txt` |
| `cmd >> file` | Redirect output to file (append) | `echo "log" >> log.txt` |
| `cmd 2>&1` | Redirect errors to stdout | `command 2>&1 \| tee log.txt` |

### Aliases (Shortcuts You Create)

Add to `~/.zshrc` (or `~/.bash_profile` for bash):

```bash
# Quick navigation
alias ..="cd .."
alias ...="cd ../.."
alias ll="ls -la"
alias la="ls -A"

# Git shortcuts
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"

# Quick edits
alias zshrc="nano ~/.zshrc"
alias reload="source ~/.zshrc"

# Custom paths
alias projects="cd ~/Projects"
alias downloads="cd ~/Downloads"
```

After editing, run `source ~/.zshrc` to apply changes!

---

## 📝 Quick Reference Card

```bash
# Navigation
pwd                     # Where am I?
ls -la                  # What's here?
cd <folder>             # Go somewhere
cd ..                   # Go back

# Files
touch file.txt          # Create file
mkdir folder            # Create folder
cp src dest             # Copy
mv src dest             # Move/rename
rm file                 # Delete (careful!)

# Viewing
cat file                # Show contents
less file               # Scroll through
head -n 20 file         # First 20 lines
tail -f file            # Watch live

# Finding
find . -name "*.txt"    # Find files
grep "text" file        # Search in file
grep -r "text" .        # Search all files

# System
top                     # Monitor processes
kill -9 PID             # Kill process
df -h                   # Disk space
du -sh folder           # Folder size

# Homebrew
brew install pkg        # Install
brew update && brew upgrade  # Update all
```

---

*Happy terminal-ing! Remember: with great power comes great responsibility... especially with `rm -rf`! 😄*

---

## 📚 Useful References & Links

| Resource | Description |
|----------|-------------|
| [Apple Terminal User Guide](https://support.apple.com/guide/terminal/welcome/mac) | Official Apple documentation for Terminal |
| [Homebrew](https://brew.sh/) | The missing package manager for macOS |
| [Oh My Zsh](https://ohmyz.sh/) | Framework for managing Zsh configuration with themes and plugins |
| [tldr pages](https://tldr.sh/) | Simplified man pages with practical examples |
| [ExplainShell](https://explainshell.com/) | Paste any command to see what each part does |
| [SS64 macOS Commands](https://ss64.com/osx/) | Comprehensive A-Z reference of macOS commands |
| [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line) | Master the command line in one page |
| [Bash Scripting Cheatsheet](https://devhints.io/bash) | Quick reference for shell scripting |
| [macOS Defaults](https://macos-defaults.com/) | Collection of macOS `defaults` commands |
| [iTerm2](https://iterm2.com/) | Popular Terminal replacement with extra features |

---

*Last updated: February 2026*