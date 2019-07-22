
function Move-User{
    <#
    .Synopsis
       Transfer AD User to new job, Department, etc.
       Calls Script located at \\<NETWORK PATH>\4Mods\Transfer_4_Mods.ps1 with params (args) entered
    .DESCRIPTION
       Transfer AD User to new job, Department, etc.
       Copies AD information such as MemberOf, Manager, Dept, etc. from the user enter for parameter -UserCopyFrom

       Will prompt running user (you) to verify the user you've entered before running
          through the main body of the script that performs the steps above.
       
       Parameter -KeepPermissions is not mandatory and defaults to $false automatically. 
       If the user needs to keep their current permissions, set -KeepPermissions to $true

       *Departments : Accounting / Cashiers / Compliance / CustomerService / DefaultDepts
                                ExecAdmin / ExecTeam / Facilities / HECM / HR / Insurance
                                InvestorReporting / Origination / Shipping / Supervisors / TaxesPayoffs
                                Treasury / IT
    .EXAMPLE
       User-Transfer -UserCopyFrom JSmith -UserCopyTo -ACatchem -Dept DefaultDepts
    .EXAMPLE
       Move-User -UserCopyFrom JSmith -UserCopyTo -ACatchem -Dept DefaultDepts -KeepPermissions $true
    #>


    [cmdletbinding()]
    [Alias('User-Transfer')]
    param(
        #Enter user to copy AD information from
        [Parameter(Mandatory=$true)]
        [string]$UserCopyFrom,

        #Enter user that is being transferred
        [Parameter(Mandatory=$true)]
        [string]$UserCopyTo,

        #Enter the Department the user is transferring to
        [Parameter(Mandatory=$true)]
        [ValidateSet("Accounting", "Cashiers", "Compliance", "CustomerService", "DefaultDepts", "ExecAdmin", "ExecTeam", "Facilities", "HECM", "HR", "Insurance", "InvestorReporting", "Origination", "Shipping", "Supervisors", "TaxesPayoffs", "Treasury", "IT")]
        [string]$Dept,

        #Optional parameter in the event the user needs to retain their current AD permissions and MemberOf Groups.
        [string]$KeepPermissions = $false

        )

    Start-Process powershell.exe -WorkingDirectory C:\temp -ArgumentList "-noprofile -command &{powershell.exe \\<NETWORK PATH>\4Mods\Transfer_4_Mods.ps1 -UserCopyFrom $UserCopyFrom -UserCopyTo $UserCopyTo -Dept $Dept -KeepPermissions $KeepPermissions}"


}

Move-JBNUser