function Change-UserName{
    <#


    #>

    [cmdletbinding()]
    [Alias('User-NameChange')]
    param(
        #Enter user's current SAMAccountName
        [Parameter(Mandatory=$true)]
        [string]$CurrentUser,

        #Enter User's NEW Lastname
        [Parameter(Mandatory=$true)]
        [string]$userNewLN,

        #Enter User's NEW Firstname
        [Parameter(Mandatory=$true)]
        [string]$userNewFN,

        #Enter User's NEW SAMAccountName
        [Parameter(Mandatory=$true)]
        [string]$NewSAMAccount
    )


    function Get-Creds{
        $script:pp = Get-Credential
    }

    Get-Creds
    Start-Process powershell.exe -Credential $script:pp -WorkingDirectory C:\temp -ArgumentList "-noprofile -command &{powershell.exe \\<NETWORK PATH>\4Mods\Name_Change_4Mods.ps1 -userChange $CurrentUser -userNewLN $userNewLN -userNewFN $userNewFN -SAMAccount $NewSAMAccount}"

}

Change-JBNUserName