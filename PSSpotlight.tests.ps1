
$ModuleName = "PSSpotlight"
$ModuleManifestName = "$ModuleName.psd1"
$ModuleManifestPath = "$PSScriptRoot\$ModuleManifestName"
Get-Module $ModuleName | Remove-Module -force
Import-Module $ModuleManifestPath

InModuleScope -ModuleName "PSSpotlight" {
    Describe "PSSpotlight" {
        Context "Variables" {
            It "landscape" {
                $config.landscape | Should -be "landscape"
            }
            It "portrait" {
                $config.portrait | Should -be "portrait"
            }
            It "Destination should be null" {
                $config.destination | Should -not -BeNullOrEmpty
                $null -eq $config.destination | Should -BeFalse
            }
        }
    }
}