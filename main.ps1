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
