###
# Author: Dave Long <dlong@cagedata.com>
# Last Udpated: 2021-07-21
# Description: Sets the default taskbar for users to include File Explorer, MS Edge, Outlook and Teams
###

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

$TaskbarLayout = @'
<?xml version="1.0" encoding="utf-8"?>
<LayoutModificationTemplate
    xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification"
    xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
    xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout"
    xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout"
    Version="1">
  <CustomTaskbarLayoutCollection PinListPlacement="Replace">
    <defaultlayout:TaskbarLayout>
      <taskbar:TaskbarPinList>

	<taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.Explorer" />
	<taskbar:DesktopApp DesktopApplicationID="Chrome" />
	<taskbar:DesktopApp DesktopApplicationID="Microsoft.Office.OUTLOOK.EXE.15" />
	<taskbar:UWA AppUserModelID="MSTeams_8wekyb3d8bbwe!MSTeams" />
	<taskbar:DesktopApp DesktopApplicationID="Microsoft.Office.WinWord.EXE.15" />
	<taskbar:DesktopApp DesktopApplicationID="Microsoft.Office.Excel.EXE.15" />

      </taskbar:TaskbarPinList>
    </defaultlayout:TaskbarLayout>
 </CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
'@
If(-Not(Test-Path C:\Scripts )){
  New-Item -Path C:\Scripts  -ItemType Directory -ErrorAction Stop | Out-Null
}
Set-Content -Path "C:\Scripts\DefaultTaskbarLayout.xml" -Value $TaskbarLayout

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -force -ea SilentlyContinue };
New-Item -Path $RegPath
New-ItemProperty -Path $RegPath -Name "StartLayoutFile" -PropertyType ExpandString -Value "C:\Scripts\DefaultTaskbarLayout.xml"
New-ItemProperty -Path $RegPath -Name "LockedStartLayout" -PropertyType DWord -Value "1"

taskkill /f /im explorer.exe

start explorer.exe

Remove-ItemProperty -path "HKLM:\software\policies\Microsoft\windows\explorer" -name startlayoutfile
Remove-ItemProperty -path "HKLM:\software\policies\Microsoft\windows\explorer" -name lockedstartlayout
