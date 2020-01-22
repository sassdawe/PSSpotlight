#requires -version 5
<#
    .SYNOPSIS
        A Windows 10 Spotlight képeinek másolása egy másik mappába file kiterjesztéssel.
        Minden anyagot elmásol a c:\users megfelelő almappáiból
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

    begin {
        #Konfigurációs állomány betöltése
        # . .\config.ps1
        . ((split-path -parent $MyInvocation.MyCommand.Definition) + "\config.ps1")


        $sufix = ".jpg"
        $fhash = $null
        $newfiles = 0

        # Forras mappák
        $srcdirectories = @()
        $sources = (Get-ChildItem c:\Users\).Name | ForEach-Object { "c:\users\$_\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\" }
        #$sources = "C:\Users\sassd\Pictures\Saved Pictures\desktop\","C:\Users\sassd\Pictures\Saved Pictures\mobile\"

        # Log file készítése
        $logfile = (split-path -parent $MyInvocation.MyCommand.Definition) + "\log\cp_log.csv"

        # Képfeldolgozáshoz
        $imagefile = New-Object -ComObject Wia.ImageFile
    }

    process {
        # Ha a cél mappának a végén nincs "\", akkor azt lekezeli.
        if ("\" -ne $destdir.substring($destdir.Length - 1)) {
            $destdir = $destdir + "\"
        }


        # Ha nincs log file, akkor azt létrehozza.
        if (! (Test-Path $logfile)) {
            New-Item $logfile -Type File -Force
            "Date;Source file;Destination file" | Out-File $logfile
        }

        # Forrás mappák keresése.
        foreach ($source in $sources) {
            if (Test-Path $source) {
                $srcdirectories += $source
            }
        }

        # Cél tesztelése
        Test-TargetFolder

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
            $srcfiles = Get-ChildItem $srcdir -Recurse


            foreach ($file in $srcfiles) {
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
        }
    }

    end {

    }
}




