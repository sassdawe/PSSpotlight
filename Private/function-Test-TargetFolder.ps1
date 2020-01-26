function Test-TargetFolder {
    [CmdletBinding()]
    param(
        # Specifies a path to one or more locations.
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "destdir",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Path to one or more locations.")]
        [Alias("PSPath")]
        [Alias("Path")]
        [ValidateNotNullOrEmpty()]
        [string]
        $destdir
    )
    if (! (Test-Path $destdir)) {
        $Timeout = 30
        Write-Host "Waiting for target: " -ForegroundColor Red -NoNewline
        Write-Host $destdir -ForegroundColor Yellow
        while (! (Test-Path $destdir) -and $Timeout -gt 0 ) {
            Write-Host -nonewline "." -ForegroundColor Yellow
            Start-Sleep 1
            $Timeout--
        }
        Write-Host ""
        Write-Host "Target available: "-ForegroundColor Green -NoNewline
        Write-Host "$destdir "-ForegroundColor Yellow

    }
    if (! (Test-Path $destdir)) {
        "$(Get-Date -Format yyyy-MM-dd) $(Get-Date -Format HH:mm:ss);;Destiantion directory not available!" | Out-File $logfile -Append
        Break
    }
}