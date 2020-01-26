<#
    .SYNOPSIS
        Save-SpotlightImages
    .DESCRIPTION
        Ha minden almappából akarunk másolni, akkor jogosultság szükséges a felhasználónak aki futtatja.
        (pl: futtathatjuk admin módban)


        $destdir: ahova a fileok kerülnek.
        $landscape: fekvő képek helye
        $portrait: álló képek helye
        $sufix: ezt a kiterjesztést kapják a fileok.
        $excludedfiles: ezek a fileok nem kerülnek másolásra.

    .PARAMETER
    .INPUTS

    .OUTPUTS

    .NOTES

    .EXAMPLE
        Save-SpotlightImages
#>
function Save-SpotlightImages {
    [CmdletBinding()]
    param (

    )

    begin {}

    process {
        $sufix = ".jpg"
        $fhash = $null
        $newfiles = 0

        # Forras mappák
        $srcdirectories = @()
        $sources = (Get-ChildItem c:\Users\).Name | ForEach-Object { "c:\users\$_\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\" }
        #$sources = "C:\Users\sassd\Pictures\Saved Pictures\desktop\","C:\Users\sassd\Pictures\Saved Pictures\mobile\"
        Write-Verbose "Count of source directories: $($sources.count)"

        # Log file készítése
        #$logfile = (split-path -parent $MyInvocation.MyCommand.Definition) + "\log\cp_log.csv"
        $logfile = (New-TemporaryFile).fullname
        Write-Verbose "Log file path: $logfile"

        # Képfeldolgozáshoz
        $imagefile = New-Object -ComObject Wia.ImageFile
    
        # Ha a cél mappának a végén nincs "\", akkor azt lekezeli.
        if ("\" -ne $destdir.substring($destdir.Length - 1)) {
            $destdir = $destdir + "\"
        }


        # Ha nincs log file, akkor azt létrehozza.
        if (! (Test-Path $logfile)) {
            New-Item $logfile -Type File -Force
            "Date;Source file;Destination file" | Out-File $logfile
        } else {
            "Date;Source file;Destination file" | Out-File $logfile
        }

        # Forrás mappák keresése.
        foreach ($source in $sources) {
            if (Test-Path $source) {
                [array]$srcdirectories += $source
            }
        }

        # Cél tesztelése
        Test-TargetFolder $destdir

        # Almappák létrehozása a célon, ha szükséges
        if (Test-Path $destdir) {
            if ( ! (Test-Path ($destdir + $landscape))) {
                New-Item ($destdir + $landscape) -ItemType Directory
            }
            if ( ! (Test-Path ($destdir + $portrait))) {
                New-Item ($destdir + $portrait) -ItemType Directory
            }

        }

        # Új fileok keresése és másolása a forrás oldalról.
        foreach ($srcdir in $srcdirectories) {
            Write-Verbose "Getting files from $srcdir"
            $srcfiles = Get-ChildItem $srcdir -Recurse
            Write-Verbose "File count: $($srcfiles.count)"

            foreach ($file in $srcfiles) {
                Write-Verbose "$($file.name)"
                if ($excludedfiles -notcontains $file) {
                    #Write-Warning "$($srcdir + $file)"

                    try {
                        $imagefile.loadfile($file.fullname)
                        if ($imagefile.height -eq 1080 -or $imagefile.width -eq 1080) {
                            if ($imagefile.height -gt $imagefile.width) {
                                $destinationdir = ($destdir + ($portrait + "\").replace('\\', '\'))
                            }
                            else {
                                $destinationdir = ($destdir + ($landscape + "\").replace('\\', '\'))
                            }
                            $fhash = Get-FileHash -Path ($srcdir + $file) -Algorithm SHA256
                            if (! (Test-Path ($destinationdir + $fhash.hash + $sufix))) {
                                $newfiles += 1
                                Copy-Item ($srcdir + $file) ($destinationdir + $fhash.hash + $sufix)
                                "$(Get-Date -Format yyyy-MM-dd) $(Get-Date -Format HH:mm:ss);$srcdir$file;$destinationdir$($fhash.Hash)$sufix" | Out-File $logfile -Append
                            }
                        }
                    }
                    catch { }
                }
            }
        }

        # Beírja a logba, ha nincs új file a forráson.
        if ($newfiles -eq 0) {
            "$(Get-Date -Format yyyy-MM-dd) $(Get-Date -Format HH:mm:ss);No new file on source.;" | Out-File $logfile -Append
            Write-Warning "There was no new file."
        } else {
            Write-Warning "We copied $newfiles new files :)"
        }
    }

    end {

    }
}




