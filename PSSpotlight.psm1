
# folder names for orientation
$script:Config = Import-Configuration
$script:landscape = $config."landscape"
$script:portrait = $config."portrait"
$script:destdir = $config."destination"
$ConfigurationPath = Get-ConfigurationPath

if ($null -eq $config.destination) {
	$script:destdir = "$([Environment]::GetFolderPath('MyPictures'))\$($config.foldername)"
	Write-Warning "For the first use, we set the default destination to `'$destdir`'`n`tYou can change it in $ConfigurationPath"
	$config.destination = $destdir
	$config | Export-Configuration
} else {
	Write-Warning "Destination directory is $destdir"
}

# TODO: store the exlusions in an editable file
# FIXME: probably we don't want to overwrite the exlusions with an update, we have to handle keeping customizations
Write-Verbose "files to exclude because Windows stores others files in the folder"
$script:excludedfiles = (
	"337cb3c65f221b47d09e214b1500c8cfc72b74bf7c871e8bb93e8b1d9f65ea5d",
	"40a9f755206f42ff800e649e294e5bb0ce1e0abd55a01171e2159803624d9366",
	"6fb41239c1eb8f5a05ed496cc2945b6b05e90f22c3f74ec6e0b8b30154d5e199",
	"dd2561c3a8b59f68c1735b10a4da4fca42d5142732cc40d892584f1b364ab9b9",
	"001223d6e8952e718ccc108deec5a96eefeff2217456541f4b53b21732b1699d",
	"43399e8cfdc9ac47fc0bf385b3669ecf51181c3785d40e4dbcdd127b6c51a798",
	"b71dabef83821ac1436c6e54eed36510be63ff7e106437b4f3d5fa2b5880d0ea",
	"aaed30865cf29ee1b9f4032c342bf49bf125d6fc7f59f0808b6d1c27bb5f1892",
	"d027c5cef9dc76de02d35ff5ba3b53e776c0c260af04c923ad7204ea18aeb0b8"
)

# use the variables to avoid getting warnings
$null = $landscape,$portrait,$excludedfiles

# TODO: load the private and public cmdlets into session
	$moduleRoot = (split-path -parent $MyInvocation.MyCommand.Definition)
	. "$moduleRoot\Public\function-Save-SpotlightImages.ps1"
	. "$moduleRoot\Public\function-Show-SpotlightConfig.ps1"
	. "$moduleRoot\Private\function-Test-TargetFolder.ps1"

# FIXME: tests, lots of unit tests using PESTER