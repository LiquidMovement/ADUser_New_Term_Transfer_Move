#####################################################################
# Part 1 // Old PC and New PC must be reachable on the Network
#           Copies the Users Desktop, My Documents (Documents in Windows 10), & Favorites
#           to C:\temp on the new PC
# Prompts user to enter Old PC Number, New PC Number & the User ID
#
# Carter C. 8/15/18
#####################################################################


$oldPC = Read-Host "Old PC Number "
$newPC = Read-Host "New PC Number "
$user = Read-Host "User ID (example CCornelius)"

$oPCPath = "\\$oldPC\C$\Users\$user"
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

    If(Test-Path $oPCPath){
        $oDesktop = "$oPCPath\Desktop"
        $oDocuments = "$oPCPath\Documents"
        $oFavorites = "$oPCPath\Favorites"

        Copy-Item $oDesktop -Destination "$nTempPCPath\Desktop" -Recurse 
        Copy-Item $oDocuments -Destination "$nTempPCPath\Documents" -recurse
        Copy-Item $oFavorites -Destination "$nTempPCPath\Favorites" -recurse 

        Write-Host "Copy from $oldPC to $newPC complete."
    }
    else{
        Write-Host "$oPCPath has failed to connect. Please ensure the PC is powered on and reachable over the Network."
    }
}
Else{
    Write-Host "$nTempPCPath has failed to connect. Please ensure the PC is powered on and reachable over the Network."
}

Pause
Exit