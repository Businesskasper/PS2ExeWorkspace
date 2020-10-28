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