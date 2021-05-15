function Get-SpotlightConfig {
    <#
        .SYNOPSIS
            Get-SpotlightConfig
        .DESCRIPTION
            Get-SpotlightConfig will show where is the configuration file

        .EXAMPLE
            PS > Get-SpotlightConfig

            Will print to the console the current location of the cofiguration file
    #>
    [CmdletBinding()]
    param (
    )
    begin {
    }
    process {
        "$ConfigurationPath\Configuration.psd1"
    }
    end {
    }
}