# Specify the name of the parent AD group
$parentGroup = "GROUP NAME"

# Get the AD group object
$group = Get-ADGroup -Identity $parentGroup

# Recursively retrieve all subgroups
$subGroups = Get-ADGroup -Filter {MemberOf -RecursiveMatch $group.DistinguishedName} -SearchBase "DC=domain,DC=com,DC=au" -SearchScope Subtree

# Select the group names of all subgroups
$groupNames = $subGroups | Select-Object -ExpandProperty Name

# Create custom objects with a "Name" property
$customObjects = $groupNames | ForEach-Object {
    [PSCustomObject]@{
        Name = $_
    }
}

# Export the subgroup names to a CSV file
$customObjects | Export-Csv -Path "enter-a-path" -NoTypeInformation