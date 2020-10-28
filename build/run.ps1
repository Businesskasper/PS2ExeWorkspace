param (

  [Switch]$silent,

  [Switch]$verbose,

  [String]$name,

  [ValidateRange(0,5)]
  [Int]$age
)

class Todo {

    [int]$id
    [int]$userId
    [string]$title
    [bool]$completed
}
class User {

    [int]$userId
    [string]$userName
    [int]$userAge
}
class Logger {

    Log([string]$textToLog) {

        Write-Host -Object $textToLog -ForegroundColor Green
    }

    LogException([Exception]$exception) {

        Write-Host -Object $_.ToString() -ForegroundColor Red
    }

    Dump([Object]$object) {

        Write-Host -Object ($object | Format-List | Out-String) -ForegroundColor Yellow
    }
}
class WebClient {

    [object]$Logger

    WebClient([object]$logger) {

        $this.Logger = $logger
    }

    [Object] Get([string]$url, [bool]$useDefaultCredentials) {

        $requestParameter = @{
            Uri = $url
        }

        if ($useDefaultCredentials) {

            $requestParameter.Add("UseDefaultCredentials", $true)
        }
        
        try {

            return $(Invoke-WebRequest @requestParameter | select -ExpandProperty Content | ConvertFrom-Json)
        }
        catch [Exception] {

            $this.Logger.LogException($_.Exception)
            throw $_
        }
    }
}
#[System.Reflection.Assembly]::LoadWithPartialName("System.Runtime.Serialization") | Out-Null

class Exetest {

    [Logger]$logger
    [WebClient]$webClient
    [Object]$appSettings

    [void] Main([bool]$silent, [bool]$verbose, [string]$name, [int]$age, [Object]$appSettings) {

        $this.appSettings = $appSettings
        $this.logger = [Logger]::new()
        $this.webClient = [WebClient]::new($this.logger)

        $baseUri = [Uri]::new($appSettings.todoApiUrl)
        $taskUri = [Uri]::new($baseUri, "1")
        $this.logger.Log("Fetche Task 1 per $($taskUri)")
       
        [Todo]$task = $this.webClient.Get($taskUri, $false)
        $this.logger.Dump($task)
    }
}




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
