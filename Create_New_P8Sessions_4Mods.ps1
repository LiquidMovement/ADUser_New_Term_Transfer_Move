    [cmdletbinding()]
    [Alias('User-P8Sessions')]
    param(
        [Parameter(Mandatory=$true)]
        [string]$user,

        [Parameter(Mandatory=$true)]
        [ValidatePattern("(IT|D)\d{1,5}$")]
        [string]$PC

        )

    $origin = "\\<NETWORK PATH>\Sessions"
    test-path $origin                    # tests above path


    $userMatch = $user.Substring(0,5) # Variable used in Sessions Copy Below AD Copy
    $userMatch.ToUpper() # Variable used in Sessions Copy Below AD Copy

    $dest = "\\$PC\C$\Users\$User"
    $destDocs = "$dest\Documents"



    #***************************FAIL SAFE WHILE LOOP -- IF PATH FAILS, LOOP PAUSES & WILL NEVER EXIT LOOP**********************
    $value = "false"                     # value default = false, when "true" - will terminate below while-loop

    while($value -eq "false")
    {
        if(test-path $destDocs)              # test destination path for new user, if valid will set $value to "true", terming loop
        {
            $value = "true"
        }
        else                             # if test-path returns false else-statement is implemented, pauses script 
        {
            write-host "Invalid Destination Path entry - script will terminate.`nConfirm the PC is on, the User has logged in at least once, and then try the module again."
            $value = "false"
            Pause
            Exit
        }
    }
    #************************************************END WHILE LOOP************************************************************


    Copy-Item $origin -recurse -Destination $destDocs    # copies Sessions from origin to destination

    cd $dest                             # defaults current to destination path
    $x = 0                               # variable to ensure rename gets "0" in new file name
    $userMatch2 = $userMatch.ToUpper()   # ensure CAPS in new file name


    #*************************************FOR LOOP TO RENAME/EDIT 1.WS, 2.WS, & 3.WS******************************************
    for($i=1; $i -le 3; $i++) #$i set to 1, will loop & term after $i=3
    {
        #*******RENAME .WS FILE NAMES*******

	    $Filter1 = $i   # $filter set to $i // file names are 1.ws, 2.ws & 3.ws // helps to quickly rename correct file
    
	    $Rename =  "DSP$userMatch2$x$i"
	    Write-Host "File to be changed '$Filter1.ws' and renamed '$Rename.ws'" 
    
        $dest2 = "$destDocs\Sessions"
	    Get-ChildItem $dest2 -Filter "*$Filter1*" -Recurse | Rename-Item -NewName {$_.name -replace "$Filter1","$Rename" }
            #Pulls the "items" in copied Session folder at destination, renaming file matching $filter w/ $rename
    

        #*******ALTER TEXT IN FILES (WORKSTATIONID)*******
        $path = "$destDocs\Sessions\$Rename.ws"     
            # variable $path = newly renamed *.ws file in Session folder

        (Get-content $path) -replace "DSPGEN0$i","$Rename" | out-file $path
            #opens newly renamed file to edit text (specifically workstationid) // replace DSPGEN01/2/3 w/ current $Rename
            #saved (out-file) to $path


        #******CREATE SHORTCUT******
        $WshShell = New-Object -comObject WScript.shell
        $Shortcut = $WshShell.CreateShortcut("$dest\Desktop\$Rename.lnk")
        $Shortcut.TargetPath = "C:\Users\$user\Documents\Sessions\$Rename.ws"
        $Shortcut.Save()
    }
    #**********************************************END FOR LOOP*************************************************************

    Write-host "File created at :"
    Get-ChildItem "$dest2" -recurse | tee-object "C:\temp\newUserSessionLog.txt"
        #Log created at above path for Directory created & files created/renamed

    Write-host '
                               $$$$$$$$$$$$$$$$$$$$
                           $$$$$$$$$$$$$$$$$$$$$$$$$$$
                        $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$         $$   $$$$$
        $$$$$$        $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$       $$$$$$$$$$
     $$ $$$$$$      $$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$$       $$$$$$$$
     $$$$$$$$$     $$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$$    $$$$$$$$
       $$$$$$$    $$$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$$$$$$$$$$$$$$
       $$$$$$$$$$$$$$$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$$$$$$  $$$$$$
        $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     $$$$
         $$$   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     $$$$$
        $$$$   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$       $$$$
        $$$    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$$$$$$$$$$$$$
       $$$$$$$$$$$$$  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$   $$$$$$$$$$$$$$$$$$
       $$$$$$$$$$$$$   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     $$$$$$$$$$$$
      $$$$       $$$$    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$      $$$$
                 $$$$$     $$$$$$$$$$$$$$$$$$$$$$$$$         $$$
                   $$$$          $$$$$$$$$$$$$$$           $$$$
                    $$$$$                                $$$$$
                     $$$$$$      $$$$$$$$$$$$$$        $$$$$
                       $$$$$$$$     $$$$$$$$$$$$$   $$$$$$$
                          $$$$$$$$$$$  $$$$$$$$$$$$$$$$$
                             $$$$$$$$$$$$$$$$$$$$$$
                                     $$$$$$$$$$$$$$$
                                         $$$$$$$$$$$$
                                          $$$$$$$$$$$
                                           $$$$$$$$
    Complete!' 

Pause
Exit