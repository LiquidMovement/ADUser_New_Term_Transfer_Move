
function Clear-JBNUser{
    <#
    .Synopsis
       Term AD User
       Module will require Termed User param
       After Termed User param is defined, script will prompt for DA Creds.
       New Powershell Window will open as DA to run script located at : 
          \\<NETWORK PATH>\4Mods\TermADUser_4_Mods.ps1 
          with Termed User param (arg)
    .DESCRIPTION
       Term AD User
       Module will require Termed User param
       After Termed User param is defined, script will prompt for DA Creds.
       New Powershell Window will open as DA to run script located at : 
          \\<NETWORK PATH>\4Mods\TermADUser_4_Mods.ps1 
          with Termed User param (arg)

       1. Adds Termed_Users Group & sets as Primary Group
       2. Removes all Group Memberships, Telephone, ipPhone
       3. Adds Termed + Date in Description & sets Department to TERMED
       4. Scrambles their Password
       5. Moves user to Google Termed OU
       
       Will prompt running user (you) to verify the user you've entered before running
          through the main body of the script that performs the steps above.
       
    .EXAMPLE
       JBNUser-Term -TermedUser JSmith
    .EXAMPLE
       Clear-JBNUser -TermedUser ACatchem
    #>

    [cmdletbinding()]
    [Alias('User-Term')]
    param(
        #Enter termed User's username
        [Parameter(Mandatory=$true)]
        [string]$TermedUser

        ) 

    function Get-Creds{
        $script:pp = Get-Credential
    }

    Get-Creds

    Start-Process powershell.exe -Credential $script:pp -WorkingDirectory C:\temp -ArgumentList "-noprofile -command &{powershell.exe \\<NETWORK PATH>\4Mods\TermADUser_4_Mods.ps1 -TermedUser $TermedUser}"


}

Clear-JBNUser