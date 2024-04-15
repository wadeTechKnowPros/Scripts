REG DELETE "HKEY_CURRENT_USER\Software\ATERA Networks" /F
del /f /q %temp%\TicketingAgentPackage
del /f /q %temp%\TrayIconCaching
del /f /q "C:\Program Files\ATERA Networks\AteraAgent\Packages\AgentPackageTicketing"
sc stop ateraagent > nul 2> nul
rmdir /q %temp%\TicketingAgentPackage
rmdir /q %temp%\TrayIconCaching
rmdir /q "C:\Program Files\ATERA Networks\AteraAgent\Packages\AgentPackageTicketing"
sc stop ateraagent > nul 2> nul
sc start ateraagent
