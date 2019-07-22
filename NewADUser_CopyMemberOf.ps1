
function New-User{
    <#
    .Synopsis
       Create New AD User
    .DESCRIPTION
       Create New AD User
       Creates new AD User based on the parameter input from the running user (you)
       Copies AD information such as Description, MemberOf, Manage, etc. from the entered user for parameter -CopyFromUser
       
       1. After entering parameter, you will be prompted for you DA credentials.
       2. After entering your DA credentials, a new Powershell Window will open using these credentials & run the script located
           at \\<NETWORK PATH>\4Mods\NewADUser_CopyMemberOf_4Mods.ps1 with the parameters (arguments) entered for the
           New User
       3. The script checks DisplayName attribute against current AD users.
       4. If the DisplayName already exists (Last name, First name) the script will prompt the running user and terminate.
       5. Script will prompt running user if the SAMAccount, UniversalPrincipalName, and/or Email exists in AD
              *Prompts for a new value if any of the above already exist in AD.
       6. Script will prompt user to verify the entered information before creating the new user.
       7. Script will prompt user again to verify the information post creating the new user before continuing.
       8. Script will copy AD info from -CopyFromUser

       *Departments : Accounting / Cashiers / Compliance / CustomerService / DefaultDepts
                                ExecAdmin / ExecTeam / Facilities / HECM / HR / Insurance
                                InvestorReporting / Origination / Shipping / Supervisors / TaxesPayoffs
                                Treasury / IT / ServiceAccounts
                                Manual (to manually enter OU when prompted during script run)

                                *When prompted for Manual OU entry -- example : OU=XXXX,DC=XXXX,DC=XXXX,DC=XXXX
    .EXAMPLE
       User-New -NewUserFN Ash -NewUserLN Catchem -SAMAccount ACatchem -TempPWD Abc123! -CopyFromUser JSmith -Dept DefaultDepts
    .EXAMPLE
       New-User -NewUserFN Ash -NewUserLN Catchem -SAMAccount ACatchem -TempPWD Abc123! -CopyFromUser JSmith -Dept Manual
    #>
    [cmdletbinding()]
    [Alias('User-New')]
    param(
        #Enter Users First Name
        [Parameter(Mandatory=$true)]
        [string]$NewUserFN,

        #Enter Users Last Name
        [Parameter(Mandatory=$true)]
        [string]$NewUserLN,

        #Enter Users SAMAccount (typically first initial & last name)
        [Parameter(Mandatory=$true)]
        [string]$SAMAccount,

        #Enter Users Temporary Password
        [Parameter(Mandatory=$true)]
        [string]$TempPWD,

        #Enter User to copy from
        [Parameter(Mandatory=$true)]
        [string]$CopyFromUser,

        #Enter User's department
        [Parameter(Mandatory=$true)]
        [ValidateSet("Accounting", "Cashiers", "Compliance", "CustomerService", "DefaultDepts", "ExecAdmin", "ExecTeam", "Facilities", "HECM", "HR", "Insurance", "InvestorReporting", "Origination", "Shipping", "Supervisors", "TaxesPayoffs", "Treasury", "IT", "ServiceAccounts", "Manual")]
        [string]$Dept

        )
    
    function Get-Creds{
        $script:pp = Get-Credential
    }

    Get-Creds

    Start-Process powershell.exe -Credential $script:pp -WorkingDirectory C:\temp -ArgumentList "-noprofile -command &{powershell.exe \\<NETWORK PATH>\4Mods\NewADUser_CopyMemberOf_4Mods.ps1 -NewUserFN $NewUserFN -NewUserLN $NewUserLN -SAMAccount $SAMAccount -TempPWD $TempPWD -CopyFromUser $CopyFromUser -Dept $Dept}"
    
}

New-JBNUser