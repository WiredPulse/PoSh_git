# PoSh_git
PoSh git is a git-like environment written in PowerShell. Any PowerShell scripts that are committed to the Master are then executed by the server with the output visible via the frontend webpage.


# Supported Functions
PoSh git currently supports the following functions:
- pull-git : Merges Branch with the Master
- push-git : Updates the Branch with latest contents from Master (only one Branch supported at this time)


# Data Flow
![Alt text](https://github.com/WiredPulse/PoSh_git/blob/master/Flow.png?raw=true "Optional Title")
<br>

# System Requirements
- Microsoft Server 2016 (180 day trial -- https://www.microsoft.com/evalcenter/evaluate-windows-server-2016?filetype=ISO)
- PowerShell 5.1+
- Internet Information Services (IIS)

# Installation
1)


# Updating Master
1. Save any PowerShell scripts you want to merge with the Master in the Branch directory<br>
2. Type "push-git"<br>
3. Within 45 seconds, the Master will be updated and output from the script will be visible on the webpage<br>
```
function test() {
  console.log("notice the blank line before this function?");
}
```
