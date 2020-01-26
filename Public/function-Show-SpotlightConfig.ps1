function Show-SpotlightConfig {
    <#
        .SYNOPSIS
            Show-SpotlightConfig
        .DESCRIPTION
            Show-SpotlightConfig will print to the console the current cofiguration in a JSON format

        .EXAMPLE
            PS > Show-SpotlightConfig

            Will print to the console the current cofiguration in a JSON format
    #>
    [CmdletBinding()]
    param (
    )
    begin {
    }
    process {
        $config | ConvertTo-Json -Depth 8 | Out-Host
    }
    end {
        }
}