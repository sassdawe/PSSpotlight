<#
    .SYNOPSIS
        Save-SpotlightImage
    .DESCRIPTION
        Save-SpotlightImage will copy the pictures from the folders which are accessile for the current user.
        To copy from all users you need to Run As Administrator
    .PARAMETER
    .INPUTS

    .OUTPUTS

    .NOTES

    .EXAMPLE
        Save-SpotlightImage
#>
function Save-SpotlightImage {
    [CmdletBinding()]
    [Alias("Copy-SpotlightImage")]
    param (

    )

    begin { }

    process {
        try {
            $extension = ".jpg"
            $fileHash = $null
            $newfiles = 0

            # Build our input of source folders
            $srcdirectories = @()
            $sources = (Get-ChildItem c:\Users\).Name | ForEach-Object { "c:\users\$_\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\" }
            Write-Verbose "Count of source directories: $($sources.count)"

            # A helper for image processing
            $imagefile = New-Object -ComObject Wia.ImageFile

            Write-Verbose "Making sure that we have an ending '\' for the destination directory"
            if ("\" -ne $destdir.substring($destdir.Length - 1)) {
                $destdir = $destdir + "\"
            }


            Write-Verbose "Validate the source directories"
            foreach ($source in $sources) {
                if (Test-Path $source) {
                    [array]$srcdirectories += $source
                }
            }
            Write-Verbose "Count of source directories after validation: $($srcdirectories.count)"

            Write-Verbose "Validation of destination folder"
            Test-TargetFolder $destdir

            Write-Verbose "Ensure we have subfolders for the different picture orientations"
            if (Test-Path $destdir) {
                if ( ! (Test-Path ($destdir + $landscape))) {
                    New-Item ($destdir + $landscape) -ItemType Directory
                }
                if ( ! (Test-Path ($destdir + $portrait))) {
                    New-Item ($destdir + $portrait) -ItemType Directory
                }

            }

            Write-Verbose "Look for new files in the source direcorties"
            foreach ($srcdir in $srcdirectories) {
                Write-Verbose "Getting files from $srcdir"
                $srcfiles = Get-ChildItem $srcdir -Recurse
                Write-Verbose "File count: $($srcfiles.count)"

                foreach ($file in $srcfiles) {
                    Write-Debug "$($file.name)"
                    if ($excludedfiles -notcontains $file) {

                        try {
                            $imagefile.loadfile($file.fullname)
                            if ($imagefile.height -eq 1080 -or $imagefile.width -eq 1080) {
                                if ($imagefile.height -gt $imagefile.width) {
                                    $destinationdir = ($destdir + ($portrait + "\").replace('\\', '\'))
                                }
                                else {
                                    $destinationdir = ($destdir + ($landscape + "\").replace('\\', '\'))
                                }
                                $fileHash = Get-FileHash -Path ($srcdir + $file) -Algorithm SHA256
                                if (! (Test-Path ($destinationdir + $fileHash.hash + $extension))) {
                                    $newfiles += 1
                                    Copy-Item ($srcdir + $file) ($destinationdir + $fileHash.hash + $extension)
                                }
                            }
                        }
                        catch {
                            throw "Something went wrong: $_"
                        }
                    }
                }
            }

            # Some verbose reporting
            if ($newfiles -eq 0) {
                Write-Verbose "There was no new file."
            }
            else {
                Write-Verbose "We copied $newfiles new files :)"
            }
        }
        catch {
            Write-Warning "Something was wrong: $_"
        }
    }

    end {

    }
}




