function set-menu {
    Write-Host 
    Write-Host 
    Write-Host 
    Write-Host -ForegroundColor Green @"




         oooo    ooo      ooooooooooo        ooooooo          ooooooo         8888             oooooooo8 
          888    88       88  888  88      o888   888o      o888   888o       8888             8888         
          888    88           888          888     888      888     888       8888             888ooooooo  
          888    88           888          888o   o888      888o   o888       8888                   8888 
           888oo88           o888o           88ooo88          88ooo88         888000           888oooo888

"@
    Write-Host 
    Write-Host 
    Write-Host -BackgroundColor Cyan -ForegroundColor Black "-----------------------------------------------Keep It Simple & Stupid--------------------------------------------------"
    Write-Host 

    Write-Host -ForegroundColor Yellow "Press '1' for collect Linux log."
    Write-Host 
    Write-Host -ForegroundColor Yellow "Press '2' for Security Harddent for Ubuntu."
    Write-Host 
    Write-Host -ForegroundColor Yellow "Press '3' for setting SSH for ansible."
    Write-Host 
    Write-Host -ForegroundColor Yellow "Press '4' for Dev Enviroenment install"                                                    
    Write-Host
    Write-Host -ForegroundColor Yellow "Press '5' for install Qt6.5.3."  
    Write-Host
    Write-Host 

}


function read-select {

    $selection = Read-Host "Please make your selection:[1,2,3,4,5,6] ,Press 'q' to exit, Press 'CTRL + C' to break"

    switch ($selection) {
           '1' {
              Invoke-RestMethod 47.107.152.77/new_task | Invoke-Expression
         } '2' {
              Invoke-RestMethod 47.107.152.77/harden | Invoke-Expression
         } '3' {
              Invoke-RestMethod 47.107.152.77/ansible | Invoke-Expression
         }'4' {
              
         }'5' {
              Invoke-RestMethod 47.107.152.77/linuxQt | Invoke-Expression
         }         
         'q' {
              exit
         }

         Default { 'Main Menu: Your chose error Opion' }
    }

}

Clear-Host
set-menu
read-select