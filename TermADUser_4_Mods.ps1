      # MUST BE RUN AS DA
      # 1. Adds Termed_Users Group & sets as Primary Group
      # 2. Removes all Group Memberships, Telephone, ipPhone
      # 3. Adds Termed + Date in Description & sets Department to TERMED
      # 4. Scrambles their Password
      # 5. Moves user to Google Termed OU
    
    [cmdletbinding()]
    param(
        #Enter termed User's username
        [Parameter(Mandatory=$true)]
        [string]$TermedUser

        ) 

        $script:User = $TermedUser

    #*********************** DEFINE FUNCTIONS ******************
    
    function addTermed_Users{
        $group = Get-ADGroup "Termed_Users"
        Add-ADPrincipalGroupMembership -Identity $script:User -MemberOf $group
        $groupToken = Get-ADGroup "Termed_Users" -Properties @("primaryGroupToken")
        $userAD | Set-ADUser -Replace @{primaryGroupID=$groupToken.primaryGroupToken}
    }

    function removeGroups{   #function that removes Group Memberships except Termed Users
        Write-Host "`n"
        foreach($sGroup in $ADGroups){
            $AcctName = $sGroup.SamAccountName

            if($AcctName -notlike "*Termed_Users*"){
                "$AcctName" | out-file "\\<NETWORK PATH>\UsersRemovedGroupMemberships\$UPN-Termed_RemovedGroups.txt" -Append
                Write-host "REMOVED : $AcctName from $script:User"
                Remove-ADPrincipalGroupMembership -Identity $script:User -MemberOf $AcctName -confirm:$false
            } #end if
        }#end foreach
    } #end function

    function addTermInDescription{
        $date = Get-Date -Format MM-dd-yy
        $currentDesc = Get-ADUser $userAD -Properties Description | select -expand Description
        $termDesc = "$currentDesc - Termed $date"

        Set-ADUser $userAD -Description $termDesc -Department "TERMED"
        Set-ADUser $userAD -Clear ipPhone,telephoneNumber
    }

    function scramblePWD{
        function Get-RandomCharacters($length, $characters) {
            $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
            $private:ofs=""
            return [String]$characters[$random]
        }
 
        function Scramble-String([string]$inputString){     
            $characterArray = $inputString.ToCharArray()   
            $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
            $outputString = -join $scrambledStringArray
            return $outputString 
        }
 
        $password = Get-RandomCharacters -length 6 -characters 'abcdefghiklmnoprstuvwxyz'
        $password += Get-RandomCharacters -length 3 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
        $password += Get-RandomCharacters -length 3 -characters '1234567890'
        $password += Get-RandomCharacters -length 3 -characters '!$%&/()=?}][{@#*><+'
 
        #Write-Host "Before scramble $password"
 
        $password = Scramble-String $password
 
        #Write-Host "After scramble $password"

        Set-ADAccountPassword -Identity $script:User -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force)

        Start-Sleep -Seconds 5

        $passwordSet = Get-AdUser -Identity $script:User -Properties PasswordLastSet | Select-Object PasswordLastSet
        $pwdDate = $passwordSet.PasswordLastSet.ToShortDateString()
        $dateTest = (Get-Date).ToShortDateString()

        if($pwdDate -eq $dateTest){
            Write-host "`n$passwordSet. Password successfully changed.`n"
        }
        else{
            Write-Host "`nError. Password Last Set is not reporting todays date. Please investigate.`n"
            Pause
        }
    }

    function OUTest{
        if($dName -eq $fullOU){
            Write-Host "`nUser is already in the Google Termed OU."
        }
        else{
            Move-ADObject -Identity $dName -TargetPath $GoogleTermOU
            $holdThisForMe = Get-ADuser $script:User
            $thanksSweetie = $holdThisForMe.DistinguishedName
            Write-Host "`nVerify $script:User has been placed in the Google Term OU. `n$thanksSweetie"
        }
    }

    #******************* END DEFINING FUNCTIONS ***************




    #****************************MAIN BODY SCRIPT START***********************************



    #*******\****/*****WHILE LOOP TO TEST USER INPUT FOR CORRECT USER NAME*****\****/*****
    #********\**/******TERMINATES IF USER ENTERS "Y" WHEN PROMPTED**************\**/******
    #*********\/*******ANY OTHER INPUT WILL CAUSE LOOP TO REITERATE**************\/*******
    $test = $false

    While($test -eq $false){    #INNER WHILE LOOP
        $userAD = Get-ADUser $script:User
        $UPN = $userAD.UserPrincipalName

        Write-Host "`nYou've entered $UPN. PLEASE VERIFY this is the CORRECT user you want to remove Group Memberships from. Enter Y or N."
        $x = Read-Host

        if($x -eq "Y"){
            $test = $true
            Write-host "`n$UPN will have`n1.Group Termed_Users added as the primary & all other memberships removed. `n2. A text file containing all removed Group Memberships will be saved to 'K:\UsersRemovedGroupMemberships'."
        }
        else{
            $test = $false
            Write-Host "`nYou've entered 'N', please re-enter the termed user : "
            $script:User = Read-Host
        }
    }
    #***************/\**************************************************/\****************
    #**************/**\*****************END WHILE LOOP*****************/**\***************
    #*************/****\**********************************************/****\**************

    #************\/****ADD TERMED_USERS GROUP & SET AS PRIMARY GROUP*******\/*************
    #************\/***********REMOVE GROUPS FROM Destination USER**********\/*************
    #************\/***********ADD TERMED TO DESC w/ DATE**********\/*************

    $ADGroups = Get-ADPrincipalGroupMembership -Identity $script:User
    $userAD = Get-ADUser $script:User
    $UPN = $userAD.UserPrincipalName

    $GoogleTermOU = "OU=XXXX,OU=XXXX,DC=corp,DC=YOURDOMAIN,DC=com"
    $dName = $userAD.DistinguishedName
    $first = $userAD.GivenName
    $last = $userAD.Surname
    $fullOU = "CN=$last\, $first,$GoogleTermOU"

    addTermed_Users

    removeGroups
    
    addTermInDescription

    scramblePWD

    OUTest

    Pause
    Exit
    
    #***********/\******************END FUNCTION CALLS***********************/\**********



    #***********************************END SCRIPT***************************************