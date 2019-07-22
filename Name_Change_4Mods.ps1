    
    
    
    [cmdletbinding()]
    param(
        #Enter user's current SAMAccountName
        [Parameter(Mandatory=$true)]
        [string]$userChange,

        #Enter User's NEW Lastname
        [Parameter(Mandatory=$true)]
        [string]$userNewLN,

        #Enter User's NEW Firstname
        [Parameter(Mandatory=$true)]
        [string]$userNewFN,

        #Enter User's NEW SAMAccountName
        [Parameter(Mandatory=$true)]
        [string]$SAMAccount
    )

$script:userChange = $userChange

    #*******\****/*****WHILE LOOP TO TEST USER INPUT FOR CORRECT USER NAME*****\****/*****
    #********\**/******TERMINATES IF USER ENTERS "Y" WHEN PROMPTED**************\**/******
    #*********\/*******ANY OTHER INPUT WILL CAUSE LOOP TO REITERATE**************\/*******
    $test = $false

    While($test -eq $false){    #INNER WHILE LOOP
        $userTest = Get-ADUser $script:userChange
        $UPN = $userTest.UserPrincipalName

        Write-Host "`nYou've entered $UPN. PLEASE VERIFY this is the CORRECT user you want to initiate a name change to. Enter Y or N."
        $x = Read-Host

        if($x -eq "Y"){
            $test = $true
            Write-host "`nYou've entered 'Y'. Script will continue.`n`n"
        }
        else{
            $test = $false
            Write-Host "`nYou've entered 'N', please re-enter the user : "
            $script:userChange = Read-Host
        }
    }
    #***************/\**************************************************/\****************
    #**************/**\*****************END WHILE LOOP*****************/**\***************
    #*************/****\**********************************************/****\**************


$userAD = Get-ADUser -identity $script:userChange -properties givenName,sn,displayName,cn,proxyAddresses,mail,sAMAccountName,userPrincipalName,name
$userOldLN = $userAD.sn
$userOldFN = $userAD.givenName

$userFull = "$userNewLN, $userNewFN"
$script:UPN = "$userNewFN.$userNewLN@YOURDOMAIN.com"
$script:Email = "$userNewFN.$userNewLN@YOURDOMAIN.com"
$script:SAMAccount = $SAMAccount
$script:userProxyNew = "SMTP:" + $userNewFN + "." + $userNewLN + "@YOURDOMAIN.com"
$script:userProxyNew2 = "smtp:" + $script:SAMAccount + "@YOURDOMAIN.com"
$script:userProxyDlt = "SMTP:" + $userOldFN + "." + $userOldLN + "@YOURDOMAIN.com"
$script:userProxyAddOld = "smtp:" + $userOldFN + "." + $userOldLN + "@YOURDOMAIN.com"

    function DisplayNameTest{
        $displayTest = $false
        While($displayTest -eq $false){
            if((Get-ADUser -Filter "DisplayName -eq '$($userFull)'")){
                Write-Host "`nDISPLAY NAME $userFull ALREADY EXISTS.`n`nSCRIPT WILL NOW TERMINATE AND EXIT."
                Write-Host "`nRE-RUN ADUser-Name ONCE A NEW DISPLAY NAME HAS BEEN DETERMINED BY HR/THE USER."
                Pause
                Exit
            }
            else{
                $displayTest = $true
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
	        }
        }
    }
	
	
	function ProxyAddressesTest{
        $proxyTest = $false
        while($proxytest -eq $false){
            if((Get-ADUser -filter "proxyAddresses -eq '$($script:userProxyNew)'")){
                $proxyTest = $false
                Write-Host "`nProxy Address $script:userProxyNew already exists"
                $newProxy = Read-Host "Please enter a different Proxy Address "
                $script:userProxyNew = "smtp:" + $newProxy
            }
            else{
                $proxyTest = $true
            }
        }
    }



DisplayNameTest
SamTest
UPNTest
EmailTest
ProxyAddressesTest


"`ndisplayName TO : $userFull" + "     FROM :   " + $userAD.displayName

"`nmail TO :  $script:Email" + "    FROM :   " + $userAD.mail

"`nsAMAccountName TO : $script:SAMAccount" + "     FROM : " + $userAD.sAMAccountName

"`nsurname TO : $userNewLN" + "     FROM :    " + $userAD.sn

"`nuserPrincipalName TO : $script:UPN" + "     FROM :    " + $userAD.userPrincipalName

"`ncn TO : $userFull" + "     FROM :    " + $userAD.cn

"`nname TO : $userFull" + "     FROM :    " + $userAD.name

"`ngiveName TO : $userNewFN" + "     FROM :    " + $userAD.givenName


"`nREVIEW INFORMATION ABOVE BEFORE CONTINUING"

Pause


if((Get-ADUser -filter "proxyAddresses -eq '$($script:userProxyDlt)'")){
    Set-ADUser -identity $script:userChange -Remove @{proxyAddresses=$script:userProxyDlt} -Add @{proxyAddresses=$script:userProxyNew,$script:userProxyAddOld,$script:userProxyNew2}
}
else{
    Set-ADUser -identity $script:userChange -Add @{proxyAddresses=$script:userProxyNew,$script:userProxyAddOld,$script:userProxyNew2}
}

Get-ADUser -Identity $script:userChange -Properties objectGUID | Rename-ADObject -NewName $userFull -PassThru | Set-ADUser -GivenName $userNewFN -Surname $userNewLN -SamAccountName $script:SAMAccount -UserPrincipalName $script:UPN -EmailAddress $script:Email -DisplayName $userFull
