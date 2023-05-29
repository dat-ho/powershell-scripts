# Enter the username of the user whose groups you want to extract
$username = Read-Host "Please enter Username:"
$resource = Read-Host "Please enter ResourceContextServer:"

# Get the user object from Active Directory
$user = Get-ADUser $username

# Get all groups that the user is a member of
$groups = Get-ADPrincipalGroupMembership $user -ResourceContextServer $resource

# Display the groups
Write-Host "Groups for user '$username':" -ForegroundColor Green
foreach ($group in $groups) {
    Write-Host $($group.Name)
}
