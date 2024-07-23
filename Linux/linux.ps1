function Set-Banner {
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
    Write-Host
}


function Show-MainMenu {
    Write-Host 
    Write-Host 
    Write-Host 
    Write-Host -ForegroundColor Yellow "-----------------------------------------------(Support Ubuntu Only)-------------------------------------------------"
    Write-Host 
    Write-Host 
    Write-Host -ForegroundColor Yellow "Press '1' for Develope Tools [build essential,Neovim]."
    Write-Host 
    Write-Host -ForegroundColor Yellow "Press '2' for Language environment build [python Goalng Rust]"
    Write-Host 
    Write-Host -ForegroundColor Yellow "Press '3' for Viusal studio code and Google chrome ,VPN"
    Write-Host 
    Write-Host -ForegroundColor Yellow "Press '4' for JetBrains [2023.2.x] Activate."                                                    
    Write-Host
    Write-Host -ForegroundColor Yellow "Press '5' for Install Qt 6.5.3 "  
    Write-Host
    Write-Host
    Write-Host 


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
         }'6' {
         }'7' {
         }
         
         'q' {
              exit
         }

         Default { 'Main Menu: Your chose error Opion' }
    }

}

function Set-LookingForJob {
    $Host.UI.RawUI.WindowTitle = "Looking For a IT system operation Job ,feel free to contact with me by Wechat# andyhusheng , thanks for your help. "    
}

function Set-MainMenu {
    Clear-Host
    Set-Banner
    Show-MainMenu
}

while (1) {
    Set-MainMenu
}