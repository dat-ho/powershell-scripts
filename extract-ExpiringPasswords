$daysToExpiration = X  # Replace X with the number of days you want to check

$users = Get-ADUser -Filter * -Properties PasswordLastSet, PasswordNeverExpires, PasswordExpired, "msDS-UserPasswordExpiryTimeComputed" |
         Where-Object {
             $_.Enabled -eq $true -and
             $_.PasswordNeverExpires -eq $false -and
             $_.PasswordExpired -eq $false -and
             $_."msDS-UserPasswordExpiryTimeComputed"
         } |
         Select-Object Name, SamAccountName, @{Name="PasswordExpiryDate"; Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

$expiringUsers = $users | Where-Object { $_.PasswordExpiryDate -lt (Get-Date).AddDays($daysToExpiration) }

$expiringUsers
