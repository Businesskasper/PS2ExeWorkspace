# PS2ExeWorkspace
A workspace to conveniently compile multiple powershell scripts into an executable. Just for fun, not to be used in production.


Once you run build.ps1, all scripts will be combined to one large file. This will then be compiled to an executable using Uses [PS2Exe](https://gallery.technet.microsoft.com/scriptcenter/PS2EXE-GUI-Convert-e7cb69d5).

To write your own app, you must define your classes and edit the entry point in run.ps1
