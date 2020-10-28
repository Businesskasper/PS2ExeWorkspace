param (

  [Switch]$silent,

  [Switch]$verbose,

  [String]$name,

  [ValidateRange(0,5)]
  [Int]$age
)

##[CLASSES]##


#Get the execution directory
if ($psISE) {

    #Script is running in ISE
    $global:root = $psISE.CurrentFile | select -ExpandProperty FullPath | Split-Path -Parent
}
else {

    if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript") {

        #Script was invoked from shell or cmd
        $global:root = $MyInvocation.MyCommand.Definition | Split-Path -Parent 
    }
    else {

        #Script was converted to an executeable
        $global:root = [System.Reflection.Assembly]::GetEntryAssembly().Location | Split-Path -Parent
    }
}


$appSettings = Get-Content -Encoding UTF8 -Path ([System.IO.Path]::Combine($global:root, "appsettings.json")) | ConvertFrom-Json

[Exetest]$exeTest = [Exetest]::new()
$exeTest.Main($silent, $verbose, $name, $age, $appSettings)