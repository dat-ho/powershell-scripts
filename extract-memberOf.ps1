Import-Module activedirectory
$username = Read-Host 'Please enter Username:'
Get-ADPrincipalGroupMembership $username -ResourceContextServer "rsmi.com.au" | Get-ADGroup -Properties * | select Name, Description, GroupScope | Sort-Object -Property Name | Format-Table -AutoSize