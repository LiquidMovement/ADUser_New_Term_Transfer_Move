    # MUST BE RUN AS DA


    [cmdletbinding()]
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
    
    $userFull = "$newUserLN, $newUserFN"
    $script:UPN = "$newUserFN.$newUserLN@YOURDOMAIN.com"
    $script:Email = "$newUserFN.$newUserLN@YOURDOMAIN.com"
    $script:OU = $null
    $script:SAMAccount = $SAMAccount
    $script:userProxy = "smtp:" + $script:SAMAccount + "@YOURDOMAIN.com"


    function OUSelect{
    $testSelect = $false
    while($testSelect -eq $false){
        if($Dept -eq "Accounting"){
            $OUInput = "Accounting"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "Cashiering"){
            $OUInput = "Cashiering"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "Compliance"){
            $OUInput = "Compliance"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "CustomerService"){
            $OUInput = "Customer Service"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "DefaultDepts"){
            $OUInput = "Default Depts"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "ExecAdmin"){
            $OUInput = "Exec Admin"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "ExecTeam"){
            $OUInput = "Exec Team"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "Facilities"){
            $OUInput = "Facilities"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "HECM"){
            $OUInput = "HECM"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "HR"){
            $OUInput = "HR"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "Insurance"){
            $OUInput = "Insurance"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "InvestorReporting"){
            $OUInput = "Investor Reporting"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "Origination"){
            $OUInput = "Origination"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "Shipping"){
            $OUInput = "Shipping"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "Supervisors"){
            $OUInput = "Supervisors"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "TaxesPayoffs"){
            $OUInput = "Taxes_Payoffs"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "Treasury"){
            $OUInput = "Treasury"
            $script:OU = "OU=$OUInput,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "IT"){
            $script:OU = "OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "ServiceAccounts"){
            $script:OU = "OU=ServiceAccounts,DC=corp,DC=YOURDOMAIN,DC=com"
            $testSelect = $true
        }
        elseif($Dept -eq "Manual"){
            Write-Host "`nLets go ahead and manually enter the OU Path."
            Write-Host "`nYou're a brave soul. Enter the full OU Path below when prompted. If you're unsure of what it is but know a current ADUser in that OU, in another Powershell window you can run Get-ADUser -Identity UserName -Properties DistinguishedName | Select-Object DistinguishedName 
        #///this command will return the OU Path you'll need to type below"
            $script:OU = Read-Host "`nPlease enter the full OU Path --- should appear to be something along the lines of OU=Default Depts,OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com" 
            $testSelect = $true
        }
        else{
            $testSelect = $false            
        }
    }
}

    function DisplayNameTest{
        $displayTest = $false
        While($displayTest -eq $false){
            if((Get-ADUser -Filter "DisplayName -eq '$($userFull)'")){
                Write-Host "`nDISPLAY NAME $userFull ALREADY EXISTS.`n`nSCRIPT WILL NOW TERMINATE AND EXIT."
                Write-Host "`nRE-RUN ADUser-New ONCE A NEW DISPLAY NAME HAS BEEN DETERMINED BY HR/THE USER."
                Pause
                Exit
            }
            else{
                $displayTest = $true
                Write-Host "`n$userFull is OK"
            }
        }
    }

    function SamTest{
        $samTest = $false
        While($samTest -eq $false){
	        if((Get-ADUser -Filter "SamAccountName -eq '$($script:SamAccount)'")){
		        Write-Host "`nSamAccountName $script:SamAccount already exists."
		        $samTest = $false
		        $script:SamAccount = Read-Host "Please enter a different SamAccountName "
	        }
	        else{
		        $samTest = $true
		        Write-Host "`n$script:SamAccount is OK"
	        }
        }
    }

    function UPNTest{
        $UPNTest = $false
        while($UPNTest -eq $false){
	        if((Get-ADUser -Filter "UserPrincipalName -eq '$script:UPN'")){
		        Write-Host "`nUniversal Principal Name $script:UPN already exists"
		        $UPNTest - $false
		        $script:UPN = Read-Host "Please enter a different UPN "
	        }
	        else{
		        $UPNTest = $true
		        Write-Host "`n$script:UPN is OK"
	        }
        }
    }

    function EmailTest{
        $EmailTest = $false
        while($EmailTest -eq $false){
	        if((Get-ADUser -Filter "EmailAddress -eq '$($script:Email)'")){
		        Write-Host "`nEmail Address $script:Email already exists"
		        $EmailTest = $false
		        $script:Email = Read-Host "Please enter a different Email address "
	        }
	        else{
		        $EmailTest = $true
		        Write-Host "`n$script:Email is OK"
	        }
        }
    }

    function ProxyAddressesTest{
        $proxyTest = $false
        while($proxytest -eq $false){
            if((Get-ADUser -filter "proxyAddresses -eq '$($script:userProxy)'")){
                $proxyTest = $false
                Write-Host "`nProxy Address $script:userProxy already exists"
                $newProxy = Read-Host "Please enter a different Proxy Address "
                $script:userProxy = "smtp:" + $newProxy
            }
            else{
                Write-Host "`n $script:userProxy is OK"
                $proxyTest = $true
            }


        }

    }

    function CopyADMemberOf{
        $SourceUser = Get-ADUser -identity $CopyFromUser -Properties Description,Office,Title,Department,Company,Manager,MemberOf


        Set-ADUser -Identity $SamAccount -Description $SourceUser.Description`
                        -Office $SourceUser.Office`
                        -Title $SourceUser.Title`
                        -Department $SourceUser.Department`
                        -Company $SourceUser.Company`
                        -Manager $SourceUser.Manager

        $CopyUser = Get-ADUser $SourceUser -prop MemberOf
        $ToUser = Get-ADUser $SamAccount -prop MemberOf
        $CopyUser.MemberOf | Where{$ToUser.MemberOf -notcontains $_} |  Add-ADGroupMember -Members $ToUser

    }

    function CreateNewUser{

        New-ADUser -name $userFUll -GivenName $newUserFN -DisplayName $userFull -Path $script:OU -userPrincipalName $script:UPN -emailAddress $script:Email -ChangePasswordAtLogon $true -SamAccountName $script:SamAccount -Surname $newUserLN -Enabled $true -AccountPassword (ConvertTo-SecureString -AsPlainText "$TempPWD" -Force)
        Set-ADUser -identity $script:SamAccount -Add @{'proxyAddresses'=$script:userProxy}

        Write-Host "`n$userFull created"
        Write-Host "`n$userFull information :`n"
        $created = Get-ADUser -Identity $script:SamAccount -Properties Name,GivenName,DisplayName,SamAccountName,DistinguishedName,userPrincipalName,EmailAddress | Select-Object Name,GivenName,DisplayName,SamAccountName,DistinguishedName,userPrincipalName,EmailAddress
        $created

        $carryOn = $false
        while($carryOn -eq $false){
            Write-Host "`nThe new users information should've printed above. If not investigate.."
            $yesNo = Read-Host "`nIf the new user printed above correctly, are you ready to Copy AD Information from a reference user? (Y/N)"

            if($yesNo -eq "Y"){
                $carryOn = $true
                CopyADMemberof
            
            }
            elseif($yesNo -eq "N"){
                Write-Host "`n You entered N. Script will pause until you're ready to carry on. Or if you're ready to exit the script, you can simply close the Powershell window now to exit."
                Pause
                $yesNo = Read-Host "`nWould you like to carry on with copy AD data now? (Y/N) "
                $carryOn = $false
            }
            else{
                $yesNo = Read-Host "Uh-oh looks like you didn't enter a Y or a N. Try again "
                $carryOn = $false
            }
        }
    }

    function ShowResults{
        Write-Host "`n
        -name $userFUll
        -GivenName $newUserFN
        -DisplayName $userFull
        -Path $script:OU
        -userPrincipalName $script:UPN
        -emailAddress $script:Email
        -proxyAddresses $script:userProxy
        -ChangePasswordAtLogon $true
        -SamAccountName $script:SamAccount
        -Surname $newUserLN
        -Enabled $true
        -AccountPassword $TempPWD"

        $continue = Read-Host "`nVerify the above looks correct. If so enter Y to continue. Enter N to terminate and prevent the user from being created."
    
        $recycle = $false
        while($recycle -eq $false){
            if($continue -eq "Y"){
                $recycle = $true
                CreateNewUser
            }
            elseif($continue -eq "N"){
                $recycle = $true
                Write-Host "`nScript will now terminate. User has not been created."
                Pause
            }
            else{
                $continue = Read-Host "`nUh oh, looks like you didn't enter a Y or a N. Try that again "
                $recycle = $false   
            }
        }
    }


    
    OUSelect
    DisplayNameTest
    SamTest
    UPNTest
    EmailTest
    ProxyAddressesTest
    ShowResults

    Write-Host "Complete"
    Pause
    Exit