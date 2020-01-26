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
    begin { }
    process {
        try {
            if (! (Test-Path $destdir)) {
                Write-Warning "The $destdir folder doesn't exist. Do you want as to create it or update the config at $ConfigurationPath?"
                New-Item -Path $destdir -ItemType Directory -Confirm:$true -Force -ErrorAction Stop
            }
        } catch {
            Write-Warning "Something was wrong: $_"
        }
    }
    end {
        if (! (Test-Path $destdir)) {
            Throw "Destination directory is missing!"
        }
    }

}