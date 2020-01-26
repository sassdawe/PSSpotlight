
$ModuleName = "PSSpotlight"
$ModuleManifestName = "$ModuleName.psd1"
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"
Get-Module $ModuleName | Remove-Module -force
Import-Module $ModuleManifestPath #-Verbose

InModuleScope -ModuleName "PSSpotlight" {

    $scripPath = [System.IO.Path]::GetDirectoryName($PSCommandPath).Replace("\Tests", "\Public");
    $testFileName = $PSCommandPath | Split-Path -Leaf;
    $targetFileName = $testFileName.Replace(".tests.", ".");
    $function = $targetFileName.Replace("function-", "").Replace(".ps1", "");

    Describe -Name "Validation tests of $function" -Fixture {
        Context -Name "Validation of file" -Fixture {
            It "$targetFileName contains a Function" {
                "$scripPath\$targetFileName" | Should -FileContentMatch -ExpectedContent "function $function"
            }
            It "$targetFileName contains an Advanced Function" {
                "$scripPath\$targetFileName" | Should -FileContentMatch -ExpectedContent "CmdletBinding()"
            }
            It "$targetFileName contains a Synopsis" {
                "$scripPath\$targetFileName" | Should -FileContentMatch -ExpectedContent ".SYNOPSIS"
            }
            It "$targetFileName is a valid script file" {
                $script = Get-Content "$scripPath\$targetFileName" -ErrorAction Stop
                $errors = $null
                [System.Management.Automation.PSParser]::Tokenize($script, [ref]$errors) | Out-Null
                $errors.Count | Should Be 0
            }
        }
    }
    Describe "Show Config" { Context "Variables" {
            Show-SpotlightConfig
        }
    }
    
}