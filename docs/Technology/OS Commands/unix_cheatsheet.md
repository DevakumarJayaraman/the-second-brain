---
title: UNIX/Linux Cheatsheet
sidebar_position: 1
displayed_sidebar: technologySidebar
tags:
  - unix
  - linux
  - terminal
  - bash
  - cheatsheet
  - cli
---

# UNIX/Linux Cheatsheet

Essential commands for daily terminal work. Your go-to reference!

---

## 📁 File & Directory Navigation

```bash
pwd                                       # Print current working directory
ls                                        # List files in current directory
ls -la                                    # List all files with details (including hidden)
ls -lh                                    # List with human-readable file sizes
ls -lt                                    # List sorted by modification time
cd <directory>                            # Change directory
cd ~                                      # Go to home directory
cd -                                      # Go to previous directory
cd ..                                     # Go up one directory
tree                                      # Display directory tree structure
tree -L 2                                 # Tree with depth limit of 2
```

---

## 📄 File Operations

```bash
touch <file>                              # Create empty file or update timestamp
cp <src> <dest>                           # Copy file
cp -r <src> <dest>                        # Copy directory recursively
mv <src> <dest>                           # Move or rename file/directory
rm <file>                                 # Remove file
rm -rf <directory>                        # Remove directory and contents (careful!)
mkdir <dir>                               # Create directory
mkdir -p <path/to/dir>                    # Create nested directories
rmdir <dir>                               # Remove empty directory
ln -s <target> <link>                     # Create symbolic link
file <filename>                           # Determine file type
stat <file>                               # Display file status and metadata
```

---

## 👀 Viewing File Contents

```bash
cat <file>                                # Display entire file content
less <file>                               # View file with pagination (q to quit)
more <file>                               # View file page by page
head <file>                               # Show first 10 lines
head -n 20 <file>                         # Show first 20 lines
tail <file>                               # Show last 10 lines
tail -n 50 <file>                         # Show last 50 lines
tail -f <file>                            # Follow file in real-time (great for logs)
wc <file>                                 # Count lines, words, characters
wc -l <file>                              # Count lines only
```

---

## 🔍 Search & Find

```bash
find . -name "*.txt"                      # Find files by name pattern
find . -type f -mtime -7                  # Files modified in last 7 days
find . -type d -name "logs"               # Find directories by name
find . -size +100M                        # Find files larger than 100MB
find . -empty                             # Find empty files and directories
locate <filename>                         # Quick find using database (run updatedb first)
which <command>                           # Show path of command
whereis <command>                         # Locate binary, source, and man page
type <command>                            # Show how command would be interpreted
```

---

## 🔎 Text Search (grep)

```bash
grep "pattern" <file>                     # Search for pattern in file
grep -i "pattern" <file>                  # Case-insensitive search
grep -r "pattern" <directory>             # Recursive search in directory
grep -n "pattern" <file>                  # Show line numbers
grep -v "pattern" <file>                  # Invert match (lines NOT matching)
grep -c "pattern" <file>                  # Count matching lines
grep -l "pattern" *                       # List files containing pattern
grep -E "regex" <file>                    # Extended regex (egrep)
grep -A 3 "pattern" <file>                # Show 3 lines after match
grep -B 3 "pattern" <file>                # Show 3 lines before match
```

---

## ✂️ Text Processing

```bash
cut -d',' -f1 <file>                      # Extract first field (comma delimiter)
cut -c1-10 <file>                         # Extract characters 1-10
sort <file>                               # Sort lines alphabetically
sort -n <file>                            # Sort numerically
sort -r <file>                            # Sort in reverse
sort -u <file>                            # Sort and remove duplicates
uniq <file>                               # Remove adjacent duplicates
uniq -c <file>                            # Count occurrences
tr 'a-z' 'A-Z' < file                     # Translate lowercase to uppercase
tr -d '\n' < file                         # Delete newlines
sed 's/old/new/g' <file>                  # Replace text (global)
sed -i 's/old/new/g' <file>               # Replace in-place
sed -n '5,10p' <file>                     # Print lines 5-10
awk '{print $1}' <file>                   # Print first column
awk -F',' '{print $2}' <file>             # Print second column (comma delim)
awk '{sum+=$1} END {print sum}' <file>    # Sum first column
```

---

## 📝 File Permissions

```bash
chmod 755 <file>                          # rwxr-xr-x (owner full, others read/exec)
chmod 644 <file>                          # rw-r--r-- (owner rw, others read)
chmod +x <file>                           # Add execute permission
chmod -w <file>                           # Remove write permission
chmod u+x <file>                          # Add execute for user only
chmod -R 755 <dir>                        # Recursive permission change
chown <user> <file>                       # Change file owner
chown <user>:<group> <file>               # Change owner and group
chown -R <user> <dir>                     # Recursive ownership change
chgrp <group> <file>                      # Change group ownership
```

---

## 💽 Disk & Storage

```bash
df -h                                     # Disk space usage (human readable)
df -i                                     # Inode usage
du -sh <dir>                              # Directory size summary
du -h --max-depth=1                       # Size of subdirectories
du -ah | sort -rh | head -20              # Top 20 largest files/dirs
lsblk                                     # List block devices
mount                                     # Show mounted filesystems
fdisk -l                                  # List disk partitions
```

---

## ⚙️ Process Management

```bash
ps                                        # List your processes
ps aux                                    # List all processes
ps aux | grep <name>                      # Find specific process
top                                       # Interactive process viewer
htop                                      # Better interactive viewer (if installed)
kill <pid>                                # Terminate process by PID
kill -9 <pid>                             # Force kill process
killall <name>                            # Kill all processes by name
pkill <pattern>                           # Kill processes matching pattern
pgrep <pattern>                           # Find PIDs by pattern
jobs                                      # List background jobs
bg                                        # Resume job in background
fg                                        # Bring job to foreground
nohup <command> &                         # Run command immune to hangups
```

---

## 🌐 Networking

```bash
ping <host>                               # Test network connectivity
curl <url>                                # Transfer data from URL
curl -O <url>                             # Download file
wget <url>                                # Download file
wget -c <url>                             # Resume download
ifconfig                                  # Show network interfaces (deprecated)
ip addr                                   # Show IP addresses (modern)
ip route                                  # Show routing table
netstat -tuln                             # List listening ports
ss -tuln                                  # Modern alternative to netstat
lsof -i :8080                             # What's using port 8080
nc -zv <host> <port>                      # Test if port is open
dig <domain>                              # DNS lookup
nslookup <domain>                         # DNS lookup (interactive)
host <domain>                             # Simple DNS lookup
traceroute <host>                         # Trace packet route
ssh <user>@<host>                         # SSH into remote host
scp <file> <user>@<host>:<path>           # Secure copy to remote
rsync -avz <src> <dest>                   # Sync files/directories
```

---

## 📦 Compression & Archives

```bash
tar -cvf archive.tar <files>              # Create tar archive
tar -xvf archive.tar                      # Extract tar archive
tar -czvf archive.tar.gz <files>          # Create gzipped tar
tar -xzvf archive.tar.gz                  # Extract gzipped tar
tar -cjvf archive.tar.bz2 <files>         # Create bzip2 tar
tar -xjvf archive.tar.bz2                 # Extract bzip2 tar
tar -tvf archive.tar                      # List contents without extracting
gzip <file>                               # Compress file (.gz)
gunzip <file.gz>                          # Decompress .gz file
zip archive.zip <files>                   # Create zip archive
unzip archive.zip                         # Extract zip archive
unzip -l archive.zip                      # List zip contents
```

---

## 📊 System Information

```bash
uname -a                                  # All system info
hostname                                  # Show hostname
uptime                                    # System uptime and load
whoami                                    # Current username
id                                        # User ID and group info
w                                         # Who is logged in and what they're doing
last                                      # Recent login history
free -h                                   # Memory usage (human readable)
cat /etc/os-release                       # OS information
lscpu                                     # CPU information
lsmem                                     # Memory information
dmesg                                     # Kernel ring buffer messages
```

---

## 🔧 Environment & Variables

```bash
env                                       # Show all environment variables
echo $PATH                                # Print PATH variable
export VAR=value                          # Set environment variable
export PATH=$PATH:/new/path               # Add to PATH
unset VAR                                 # Remove environment variable
printenv VAR                              # Print specific variable
source ~/.bashrc                          # Reload bash config
alias ll='ls -la'                         # Create alias
alias                                     # List all aliases
history                                   # Show command history
history | grep <cmd>                      # Search history
!<number>                                 # Run command from history
!!                                        # Repeat last command
```

---

## 📡 Pipes & Redirection

```bash
command > file                            # Redirect stdout to file (overwrite)
command >> file                           # Redirect stdout to file (append)
command 2> file                           # Redirect stderr to file
command &> file                           # Redirect both stdout and stderr
command < file                            # Use file as stdin
command1 | command2                       # Pipe output to another command
command | tee file                        # Pipe and also save to file
command1 && command2                      # Run command2 if command1 succeeds
command1 || command2                      # Run command2 if command1 fails
command1 ; command2                       # Run both regardless of result
```

---

## 🛠️ Useful One-Liners

```bash
# Find and delete files older than 30 days
find . -type f -mtime +30 -delete

# Count files in directory
find . -type f | wc -l

# Find largest files in directory
find . -type f -exec du -h {} + | sort -rh | head -10

# Replace text in multiple files
find . -name "*.txt" -exec sed -i 's/old/new/g' {} +

# Monitor log file in real-time with highlighting
tail -f /var/log/syslog | grep --color=auto "error"

# Get your public IP
curl -s ifconfig.me

# Quick HTTP server (Python 3)
python3 -m http.server 8000

# Generate random password
openssl rand -base64 16

# Check if port is in use
lsof -i :<port> || echo "Port is free"

# Recursively find duplicate files by checksum
find . -type f -exec md5sum {} + | sort | uniq -d -w32
```

---

## 📚 Useful Links

| Resource | Link |
|----------|------|
| GNU Coreutils Manual | [gnu.org/software/coreutils/manual](https://www.gnu.org/software/coreutils/manual/coreutils.html) |
| Linux Man Pages | [man7.org](https://man7.org/linux/man-pages/) |
| ExplainShell | [explainshell.com](https://explainshell.com/) |
| TLDR Pages | [tldr.sh](https://tldr.sh/) |
| Linux Command Library | [linuxcommandlibrary.com](https://linuxcommandlibrary.com/) |
| SS64 Command Reference | [ss64.com/bash](https://ss64.com/bash/) |
| Bash Reference Manual | [gnu.org/software/bash/manual](https://www.gnu.org/software/bash/manual/bash.html) |
| ShellCheck | [shellcheck.net](https://www.shellcheck.net/) |

---

:::tip Pro Tips
- Use `man <command>` to read the manual for any command
- Press `Tab` for auto-completion
- Use `Ctrl+R` to search command history
- Use `Ctrl+C` to cancel, `Ctrl+Z` to suspend
- Wrap variables in quotes: `"$VAR"` to handle spaces
- Use `--help` flag for quick command help
:::

---

*Last updated: February 2026*