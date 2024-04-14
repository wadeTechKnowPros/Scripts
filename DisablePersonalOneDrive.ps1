# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

New-Item "HKCU:\SOFTWARE\Policies\Microsoft\OneDrive" -Force
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive' -Name 'DisablePersonalSync' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive' -Name 'DisableFREAnimation' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;