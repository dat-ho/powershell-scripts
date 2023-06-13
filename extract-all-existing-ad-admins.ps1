# Import the Active Directory module
Import-Module ActiveDirectory

# Define the admin group name(s)
$adminGroups = "Administrators", "Domain Admins" # Add or modify the group names as needed

# Iterate through each admin group
foreach ($group in $adminGroups) {
    # Retrieve members of the admin group
    $members = Get-ADGroupMember -Identity $group

    # Filter, display only users and export to CSV
    $csvPath = "C:\Path\to\output.csv"  # Specify the desired file path and name
    $users = $members | Where-Object { $_.objectClass -eq 'user' }
    $users | Select-Object Name, SamAccountName | Export-Csv -Path $csvPath -NoTypeInformation
}