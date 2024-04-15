# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

Taskkill /im SupportAssistAgent.exe /F

Remove-Item -Path "HKCU:\Software\ATERA Networks" -Recurse
Remove-Item -Force -Recurse -Path C:\Windows\Temp\TicketingAgentPackage
Remove-Item -Force -Recurse -Path C:\Windows\Temp\TrayIconCaching
Remove-Item -Force -Recurse "C:\Program Files\ATERA Networks\AteraAgent\Packages\AgentPackageTicketing"
Remove-Item -Force -Recurse "C:\Program Files (x86)\ATERA Networks\AteraAgent\Packages\AgentPackageTicketing"

Stop-Service AteraAgent
Start-Service AteraAgent

