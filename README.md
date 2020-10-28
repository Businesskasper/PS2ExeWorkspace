# PS2ExeWorkspace
A workspace to conveniently compile multiple powershell scripts into an executable. Just for fun, not to be used in production.

Uses (PS2Exe)[https://gallery.technet.microsoft.com/scriptcenter/PS2EXE-GUI-Convert-e7cb69d5]

### How it works

You can write your own powershell classes and save them as .ps1 files. To init the app, use the entry point in main.ps1 and the invocation part in run.ps1. To deploy an .exe, just invoke build.ps1.
