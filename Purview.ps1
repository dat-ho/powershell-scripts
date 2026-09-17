Connect-IPPSSession

#Label Publishing Policy Settings
(Get-LabelPolicy -Identity "Standard").Settings

#Set label custom help page
Set-LabelPolicy -Identity "IP-LabelPublishing-ForTesting-B" -AdvancedSettings @{customhelpurl="URL goes here"}
