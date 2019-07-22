#####################################################################
# Part 2 // Part 1 must have successfully been run and the New PC must be reachable on the Network
#           Moves the Users Desktop, My Documents (Documents in Windows 10), & Favorites
#           from C:\temp on the new PC to the Users profile on C:\Users\<UserProfile>
# Prompts user to enter New PC Number & the User ID
#
# Carter C. 8/15/18
#####################################################################


$newPC = Read-Host "New PC Number "
$user = Read-Host "User ID (example CCornelius)"

$selection = Read-Host "AWS Workspace? Y or N."

if($selection -eq "Y"){
    $nPCPath = "\\$newPC\D$\Users\$user"
    $nTempPCPath = "\\$newPC\D$\temp"
}
else{
    $nPCPath = "\\$newPC\C$\Users\$user"
    $nTempPCPath = "\\$newPC\C$\temp"
}


If(Test-Path $nTempPCPath){

    If(Test-Path $nPCPath){
            Get-ChildItem "$nTempPCPath\Desktop" -Recurse | Move-Item -Destination "$nPCPath\Desktop" -force -ErrorAction SilentlyContinue
            Get-ChildItem "$nTempPCPath\Documents" -Recurse | Move-Item -Destination "$nPCPath\Documents" -Force -ErrorAction SilentlyContinue
            Get-ChildItem "$nTempPCPath\Favorites" -Recurse | Move-Item -Destination "$nPCPath\Favorites" -Force -ErrorAction SilentlyContinue

            Write-Host "Copy from $nTempPCPath to $nPCPath complete."

            Remove-Item "$nTempPCPath\Desktop" -Force -Recurse -ErrorAction SilentlyContinue
            Remove-Item "$nTempPCPath\Documents" -Force -Recurse -ErrorAction SilentlyContinue
            Remove-Item "$nTempPCPath\Favorites" -Force -Recurse -ErrorAction SilentlyContinue
    } # end if(Test-Path $nPCPath)
    Else{
            Write-Host "$nPCPath has failed to connect. Please ensure the PC is powered on and reachable over the Network, and that the user has 
successfully logged into the New PC to create the user's folder within $newPC\C:\Users\."
    }
}
Else{
    Write-Host "$nTempPCPath has failed to connect. Please ensure the PC is powered on and reachable over the Network."
}

Pause