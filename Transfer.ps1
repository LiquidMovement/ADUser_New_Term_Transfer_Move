#****************************************************************************************************************
#*Carter C. -- 12/28/18
#*
#*Employee Transfer Script - Alters AD Data for New Position/Department/OU
#*Script removes Current Group Memberships from the destination user
#*After removal, copies AD Data from source user to destination user
#*Moves User to selected Dept
#*Departments : Accounting / Cashiers / Compliance / CustomerService / DefaultDepts
#                                ExecAdmin / ExecTeam / Facilities / HECM / HR / Insurance
#                                InvestorReporting / Origination / Shipping / Supervisors / TaxesPayoffs
#                                Treasury / IT
#*Prompts if user needs to keep current permissions --- if so it will reinstate the removed Groups
#****************************************************************************************************************


    [cmdletbinding()]
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

        #Enter $true or $false if the user needs to keep their current MemberOf
        [Parameter(Mandatory=$true)]
        [string]$KeepPermissions = $false

        )

        $script:CopyToUser = $UserCopyTo

        function removeGroups{   #function that removes Group Memberships except Domain Users & FileShares##
            Write-Host "`n"
            foreach($sGroup in $ADGroups){
                $AcctName = $sGroup.SamAccountName

                if($AcctName -notlike "*Domain Users*"){
                    "$AcctName" | out-file "\\<NETWORK PATH>\$UPN-Transfer_RemovedGroups.txt" -Append
                    Write-host "$script:CopyToUser + $AcctName"
                    Remove-ADPrincipalGroupMembership -Identity $script:CopyToUser -MemberOf $AcctName -confirm:$false
                } #end if
            }#end foreach
        } #end function


        function MoveOU{
            if($Dept -eq "Accounting"){
                $OU = "OU=Accounting,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "Cashiers"){
                $OU = "OU=Cashiers,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "Compliance"){
                $OU = "OU=Complaince,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "CustomerService"){
                $OU = "OU=Customer Service,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "DefaultDepts"){
                $OU = "OU=Default Depts,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "ExecAdmin"){
                $OU = "OU=Exec Admin,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "ExecTeam"){
                $OU = "OU=Exec Team,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "Facilities"){
                $OU = "OU=Facilities,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "HECM"){
                $OU = "OU=HECM,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "HR"){
                $OU = "OU=HR,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "Insurance"){
                $OU = "OU=Insurance,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "InvestorReporting"){
                $OU = "OU=Investor Reporting,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "Origination"){
                $OU = "OU=Origination,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "Shipping"){
                $OU = "OU=Shipping,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "Supervisors"){
                $OU = "OU=Supervisors,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "TaxesPayoffs"){
                $OU = "OU=Taxes_Payoffs,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "Treasury"){
                $OU = "OU=Treasury,OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            elseif($Dept -eq "IT"){
                $OU = "OU=XXXX,OU=XXXX,DC=XXXX,DC=XXXX,DC=com"
                Move-ADObject -Identity $dName -TargetPath $OU
            }
            else{
                Write-Host "Invalid selection, script will terminate -- please manually move the user to the new OU"
            }    
        }


        function restoreGroups{       #function that removes Group Memberships except Domain Users
            $prevMember = Get-Content -path "\\<NETWORK PATH>\$UPN-Transfer_RemovedGroups.txt"     #retrieves the text file created during the users Disabling via the Disable Script

            foreach($group in $prevMember){
                Add-ADPrincipalGroupMembership -Identity $script:CopyToUser -MemberOf $group
            } #end foreach
    
        }#end function


        #**** MAIN FUNCTION START ****

        #*******\****/*****WHILE LOOP TO TEST USER INPUT FOR CORRECT USER NAME*****\****/*****
        #********\**/******TERMINATES IF USER ENTERS "Y" WHEN PROMPTED**************\**/******
        #*********\/*******ANY OTHER INPUT WILL CAUSE LOOP TO REITERATE**************\/*******
        $test = $false

        While($test -eq $false){    #INNER WHILE LOOP
            $userAD = Get-ADUser $script:CopyToUser
            $UPN = $userAD.UserPrincipalName

            Write-Host "`nYou've entered $UPN. PLEASE VERIFY this is the CORRECT user you want to remove Group Memberships from. Enter Y or N."
            $x = Read-Host

            if($x -eq "Y"){
                $test = $true
                Write-host "`n$UPN will have`n1.Group memberships (except Domain Users) removed. `n2. AD info from $UserCopyFrom copied to $script:CopyToUser `n& A text file containing all removed Group Memberships will be saved to '\\<NETWORK PATH>\UsersRemovedGroupMemberships'."
            }
            else{
                $test = $false
                Write-Host "`nYou've entered 'N', please re-enter the destination user to copy to : "
                $script:CopyToUser = Read-Host
            }
        }
        #***************/\**************************************************/\****************
        #**************/**\*****************END INNER WHILE LOOP***********/**\***************
        #*************/****\**********************************************/****\**************


        #************\/***********REMOVE GROUPS FROM Destination USER**********\/*************

        $ADGroups = Get-ADPrincipalGroupMembership -Identity $script:CopyToUser
        $userAD = Get-ADUser $script:CopyToUser
        $UPN = $userAD.UserPrincipalName

        removeGroups
        #***********/\**********************END REMOVE*************************/\**********


        #******\****/*********************************************************\****/*******
        #*******\**/******COPY AD CREDS FROM UserCopyFrom TO CopyToUser********\**/********
        #********\/*************************************************************\/*********

        $SourceUser = Get-ADUser -identity $UserCopyFrom -Properties Description,Office,Title,Department,Company,Manager,MemberOf

        Set-ADUser -Identity $script:CopyToUser -Description $SourceUser.Description`
                        -Office $SourceUser.Office`
                        -Title $SourceUser.Title`
                        -Department $SourceUser.Department`
                        -Company $SourceUser.Company`
                        -Manager $SourceUser.Manager

        $CopyUser = Get-ADUser $SourceUser -prop MemberOf
        $ToUser = Get-ADUser $script:CopyToUser -prop MemberOf
        $CopyUser.MemberOf | Where{$ToUser.MemberOf -notcontains $_} |  Add-ADGroupMember -Members $ToUser

        #***********************************************************************************

        #**************
        #**************
        #**************
        $dName = $userAD.DistinguishedName

        MoveOU
        #**********************************

        if($KeepPermissions -eq $true){
            restoreGroups
        }
        else{
            Write-Host "Previous Group Membership not restored"
        }