# PoSh_git
PoSh git is a git-like environment written in PowerShell. Any PowerShell scripts that are committed to the Master are then executed by the server with the output visible via the frontend webpage.

# Supported Functions
PoSh git currently supports the following functions:
- pull-git : Merges Branch with the Master<br>
- push-git : Updates the Branch with latest contents from Master
<br>
<br>
<br>
# Data Flow
![Alt text](https://github.com/WiredPulse/PoSh_git/blob/master/Flow.png?raw=true "Optional Title")
<br>
<br>
Currently, PoSh git supports only one branch



# Installation


git-like environment in PowerShell


# Updating Master
1. Save any PowerShell scripts you want to merge with the Master in the Branch directory<br>
2. Type "push-git"<br>
3. Within 45 seconds, the Master will be updated and output from the script will be visible on the webpage<br>
```
function test() {
  console.log("notice the blank line before this function?");
}
```
