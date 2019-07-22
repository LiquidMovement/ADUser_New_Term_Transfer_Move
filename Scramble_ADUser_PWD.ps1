$user = Read-Host "AD User to scramble password : "

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
 
Write-Host "After scramble $password`n"

Set-ADAccountPassword -Identity $user -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force)
Start-Sleep -Seconds 3
$passwordSet = Get-AdUser -Identity $user -Properties PasswordLastSet | Select-Object PasswordLastSet
$pwdDate = $passwordSet.PasswordLastSet.ToShortDateString()
#$dateTest = Get-Date -format MM/dd/yyyy
$dateTest = (Get-Date).ToShortDateString()

if($pwdDate -eq $dateTest){
    Write-host "$passwordSet. Password successfully changed."
}
else{
    Write-Host "Error. Password Last Set is not reporting todays date. Please investigate."
    Pause
}