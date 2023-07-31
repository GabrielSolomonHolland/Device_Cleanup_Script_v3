#Gabriel Solomon Holland

#Set-ExecutionPolicy -ExecutionPolicy bypass
$ErrorActionPreference = 'silentlyContinue'

### Bloatware software to be removed ###

$thingsToRemove =
"Microsoft.HEIFImageExtension",
"Microsoft.VP9VideoExtensions",
"Microsoft.MPEG2VideoExtension",
"Microsoft.HEVCVideoExtension",
"Microsoft.AV1VideoExtension",
"Microsoft.WebpImageExtension",
"Microsoft.MSPaint",
"Microsoft.Microsoft3DViewer",
"Microsoft.3DBuilder",
"Microsoft.Print3D",
"Microsoft.SkypeApp",
"Microsoft.MixedReality.Portal",
"Microsoft.MicrosoftSolitaireCollection",
"Microsoft.ZuneVideo",
"Microsoft.ZuneMusic",
"Microsoft.Windows.CBSPreview",
"Microsoft.MicrosoftOfficeHub",
"Microsoft.Whiteboard",
"Microsoft.YourPhone",
"Microsoft.Wallet",
"Microsoft.WindowsPhone",
"Microsoft.People",
"Microsoft.BingWeather",
"Microsoft.BingNews",
"Microsoft.BingSports",
"Microsoft.windowscommunicationsapps",
"Microsoft.ScreenSketch",
"Microsoft.WindowsFeedbackHub",
"Microsoft.GetHelp",
"Microsoft.WindowsSoundRecorder",
"Microsoft.Advertising.Xaml",
"Microsoft.Xbox.TCUI",
"Microsoft.XboxGamingOverlay",
"Microsoft.XboxGameOverlay",
"Microsoft.XboxApp",
"Microsoft.XboxSpeechToTextOverlay",
"Microsoft.XboxIdentityProvider",
"Microsoft.GamingApp",
"AD2F1837.HPEasyClean",
"AD2F1837.HPPowerManager",
"AD2F1837.HPPrivacySettings",
"AD2F1837.HPQuickDrop",
"AD2F1837.myHP",
"AD2F1837*",
"*HP*",
"MirametrixInc.GlancebyMirametrix",
"DolbyLaboratories.DolbyAccess",
"ClipChamp.ClipChamp",
"*EclipseManager*",
"*ActiproSoftwareLLC*",
"*AdobeSystemsIncorporated.AdobePhotoshopExpress*",
"*Duolingo-LearnLanguagesforFree*",
"*PandoraMediaInc*",
"*CandyCrush*",
"*BubbleWitch3Saga*",
"*Wunderlist*",
"*Flipboard*",
"*Twitter*",
"*Facebook*",
"*Netflix*",
"*Whatsapp*",
"*Kindle*",
"*Spotify*",
"*Minecraft*",
"*Royal Revolt*",
"*Sway*",
"*Instagram*",
"*Prime*",
"*Linkedin*",
"*Speed Test*",
"*Dolby*",
"*Zune*",
"*Groovy*",
"E046963F.LenovoSettingsforEnterprise"

foreach($appPackage in $thingsToRemove){
    Get-AppxPackage -name $appPackage -AllUsers | Remove-AppxPackage -AllUsers
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $appPackage | Remove-AppxProvisionedPackage -Online
    Write-Output "Removing $appPackage."
    }

#additional HP bloatware packages

$HPBloatware = "HP Security Update Service",
"HP Notifications",
"HP PC Hardware Diagnostics UEFI",
"HP Sure Run Module",
"HP Sure Recover",
"HP Wolf Security Application Support for Sure Sense",
"HP Wolf Security Application Support for Office",
"HP Wolf Security - Console",
"HP System Default Settings",
"HP Wolf Security",
"HP Wolf*"

foreach($bloat in $HPBloatware)
    {
    Write-Host "Removing $bloat"
    $remove = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq $bloat}
    $remove.Uninstall()
    }
Start-Sleep -seconds 3 #Just wait a second before second iteration

Write-Host "Double checking removal...."
foreach($bloat in $HPBloatware) #Run second time because some of the things above require others to be uninstalled first.
    {
    $remove = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq $bloat}
    $remove.Uninstall()
    }

### Clearing Registry Values ###
### Huge thanks to https://github.com/Sycnex/Windows10Debloater/blob/master/Windows10Debloater.ps1 ###

#Stop cortana from being used as part of Windows Search
Write-Host "Removing Cortana from Search"
$Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    If (Test-Path $Search) {
        Set-ItemProperty $Search AllowCortana -Value 0 
    }

#Disables Web Search in Start Menu
Write-Host "Removing Bing Search from Search Menu"
$WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0 
If (!(Test-Path $WebSearch)) {
    New-Item $WebSearch
    }

#Prevents bloatware applications from returning and removes Start Menu suggestions      
Write-Host "Preventing Bloatware from Returning"         
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$registryOEM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
If (!(Test-Path $registryPath)) { 
        New-Item $registryPath
    }
Set-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1 

If (!(Test-Path $registryOEM)) {
        New-Item $registryOEM
    }
Set-ItemProperty $registryOEM  ContentDeliveryAllowed -Value 0 
Set-ItemProperty $registryOEM  OemPreInstalledAppsEnabled -Value 0 
Set-ItemProperty $registryOEM  PreInstalledAppsEnabled -Value 0 
Set-ItemProperty $registryOEM  PreInstalledAppsEverEnabled -Value 0 
Set-ItemProperty $registryOEM  SilentInstalledAppsEnabled -Value 0 
Set-ItemProperty $registryOEM  SystemPaneSuggestionsEnabled -Value 0 

#Remove registry keys for bloatware
Write-Host "Scrubbing bloatware registry keys"
$Keys = @(
            
        #Remove Background Tasks
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
        #Windows File
        "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            
        #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
        #Scheduled Tasks to delete
        "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
            
        #Windows Protocol Keys
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
               
        #Windows Share Target
        "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    )
 
#Remove keys       
    ForEach ($Key in $Keys) {
        Remove-Item $Key -Recurse
    }
### End Github Help ###

#Optional Things
 
### Update group policy ###
$choice = Read-Host -prompt "Update group policy? (Y/N)"
if($choice -imatch "Y"){Write-Output "Starting Update... Please Wait..."; gpupdate /force}


### Clear temp files ###
$choice = Read-Host -prompt "Clear temporary files? (Y/N)"
if($choice -imatch "Y"){
    Write-Output "Clearing Temp Files"
    Remove-Item $env:TEMP\* -Recurse -Force #Clear Windows Temp Folder

    Write-Output "Clearing Obsolete Updates"
    dism /online /Cleanup-Image /StartComponentCleanup #Clear old Windows Updates

    Write-Output "Clearing User Temp Folders"
    forEach($profile in Get-WmiObject Win32_userprofile | select-object -ExpandProperty localpath){ #Clear user temp folder
        $tempFolderPath = $profile + "\AppData\Local\Temp\"
        if(-not($tempFolderPath.contains("Windows"))){ #If it does not contain "Windows" ie is not a service account
            dir $tempFolderPath -Recurse | Remove-Item -Force -Recurse}
        }

    Clear-RecycleBin -Force #Clear out recycle bin
    Write-Output "Recycle bin cleared"    
}


### Health Check ###
$choice = Read-Host -prompt "Run Health Check? (Y/N)"
if($choice -imatch "Y"){
    sfc /scannow
    DISM /online /cleanup-image /restorehealth
}

#reset execution policy for security best practices.
Set-ExecutionPolicy -ExecutionPolicy Default