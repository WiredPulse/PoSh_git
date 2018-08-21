# PoSh_git
PoSh git is a git-like environment written in PowerShell. Any PowerShell scripts that are committed to the Master are then executed by the server with the output visible via frontend webpage. The webserver listens on 443 and is SSL encrypted via self-signed certificate.


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
1) Clone the repo to c:\ and uncompress it
2) Execute the git.ps1 script
```
PS C:\> .\git.ps1
```
3) Copy the demo.ps1 script to the stager directory
```
PS C:\> copy-item c:\
```
4. Open a browswer and navigate to https://localhost
5. When prompted log in with **admin:empiredidnothingwrong**


# Updating the Master
1. Save any PowerShell scripts you want to merge with the Master in the Branch directory<br>
2. Type:
```
PS C:\> pull-git
```
3. Within 45 seconds, the Master will be updated and output from the script will be visible on the webpage<br>

# Updating Branch with latest Master
1. Type:
```
PS C:\> push-git
```

# Additional Notes
- The after git.ps1 is executed once, the webserver will continuously run without the need for PowerShell
- The backend git-environment only runs when git.ps1 is running, terminating the PowerShell instance running the script kills the program
