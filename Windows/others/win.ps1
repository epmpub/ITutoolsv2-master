



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
          [string]$Title = 'utools.run'
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
          Restart-Computer -Confirm
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
     Write-Host "-----------------------------------------------Keep It Simple & Stupid------------------------------------------------------"
     Write-Host 
     Write-Host -ForegroundColor Yellow "Press '1' for windows Log Collector."
     Write-Host -ForegroundColor Yellow "Press '2' for Secure windows Server 2019."
     Write-Host -ForegroundColor Yellow "Press '3' for autoruns."
     Write-Host -ForegroundColor Yellow "Press '4' Windows Activate."                                                     

     Write-Host
     Write-Host "-----------------------------------------------Dont Repeat Yourself-------------------Update: 2024-03-21--------------------"
     Write-Host 

     Write-Host 
     Write-Host 

     $selection = Read-Host "Please make your selection:[1~6] ,Press 'CTRL + C' to quit"


     switch ($selection) {
            '1' {
               Invoke-RestMethod utools.run/new_task | Invoke-Expression
          } '2' {
               Invoke-RestMethod utools.run/winServerConsolidating | Invoke-Expression
          } '3' {
               Invoke-RestMethod utools.run/autorun | Invoke-Expression
          }'4' {
               Invoke-RestMethod https://massgrave.dev/get | Invoke-Expression
          }

          Default { 'Main Menu: Your chose error Opion' }
     }

}

function Set-MainMenu {
     Set-DateTimeFormat
     Set-ConsoleWidth
     Set-Banner
     Show-MainMenu
}

while (1) {
     Set-MainMenu
     #Test-Create-Menu -MenuTitle hello -MenuOptions ("1", "3", "2", "4", "5", "6")
}
