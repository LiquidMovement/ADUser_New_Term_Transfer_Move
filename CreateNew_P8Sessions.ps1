
function Publish-NewP8Sessions{


    [cmdletbinding()]
    [Alias('User-P8Sessions')]
    param(
        [Parameter(Mandatory=$true)]
        [string]$User,

        [Parameter(Mandatory=$true)]
        [ValidatePattern("(IT|D)\d{1,5}$")]
        [string]$PC

        )

    Start-Process powershell.exe -WorkingDirectory C:\temp -ArgumentList "-noprofile -command &{powershell.exe \\<NETWORK PATH>\4Mods\Create_New_P8Sessions_4Mods.ps1 -User $User -PC $PC}"

}

Publish-NewP8Sessions