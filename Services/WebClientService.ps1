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