param (
    
    [string]$pathToPS2EXE = "C:\Tools\PS2EXE\ps2exe.ps1"
)

$MyInvocation.MyCommand.CommandType
#Get the execution directory
if ($psISE) {

    #Script is running in ISE
    $scriptDir = $psISE.CurrentFile | select -ExpandProperty FullPath | Split-Path -Parent
}
else {

    if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript") {

        #Script was invoked from shell or cmd
        $scriptDir = $MyInvocation.MyCommand.Definition | Split-Path -Parent 
    }
    else {

        #Script was converted to an executeable
        $scriptDir = [System.Reflection.Assembly]::GetEntryAssembly().Location | Split-Path -Parent
    }
}

Write-Host "Running from $($scriptDir)" -ForegroundColor Cyan


#
#Build run script
#

$classesContent = [String]::Empty

foreach ($psFile in (Get-ChildItem -Path $scriptDir -Filter "*.ps1" -Exclude @("run.ps1", "build.ps1", "appsettings.json") -Recurse)) {

    Write-Host "Adding $($psFile.Name)" -ForegroundColor Cyan

    $content = [System.IO.File]::ReadAllText($psFile.FullName)
    $classesContent += $content + [System.Environment]::NewLine
}

$runScript = Get-Content -Path ([System.IO.Path]::Combine($scriptDir, "run.ps1"))
$runScript = $runScript.Replace("##[CLASSES]##", $classesContent)

$outDir = [System.IO.Path]::Combine($scriptDir, "build")
$outPath = [System.IO.Path]::Combine($outDir, "run.ps1")
Remove-Item -Path $outDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path $outDir -ItemType Directory -Force | Out-Null

Write-Host "Writing run script to $($outPath)" -ForegroundColor Cyan
$runScript | Out-File -Encoding utf8 -FilePath $outPath

Write-Host "Copying appsettings.json" -ForegroundColor Cyan
Copy-Item -Path ([System.IO.Path]::Combine($scriptDir, "appsettings.json")) -Destination ([System.IO.Path]::Combine($outDir, "appsettings.json"))

#
#Compile to executable
#

$outputFile = $outPath.Replace('.ps1', '.exe')
Write-Host "Building to $($outputFile)" -ForegroundColor Cyan
Invoke-Expression -Command ". $($pathToPS2EXE) -inputFile $($outPath) -outputFile $outputFile -verbose -runtime40 -x64 -MTA -requireAdmin" | Out-Null
