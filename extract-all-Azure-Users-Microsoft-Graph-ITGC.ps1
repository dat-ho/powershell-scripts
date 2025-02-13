# Migrate scripts to Microsoft Graph PowerShell SDK

# If you encounter errors about running scripts being disabled,
# run the following command in your PowerShell session before executing this script:
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Install the Microsoft Graph module if not installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Install-Module -Name Microsoft.Graph -AllowClobber -Force -Verbose
}

# Import the Microsoft Graph module
Import-Module Microsoft.Graph

# Connect to Microsoft Graph (interactive login)
Connect-MgGraph -Scopes "User.Read.All", "GroupMember.Read.All"

# Get all users with all available properties
$users = Get-MgUser -All -Property *

# Array to store user data
$userData = @()

# Loop through each user and extract properties
foreach ($user in $users) {
    # Get group memberships for the user using Microsoft Graph
    $groupsRaw = Get-MgUserMemberOf -UserId $user.Id -All
    # Filter to include only group objects (objects with '@odata.type' equal to '#microsoft.graph.group')
    $groups = $groupsRaw | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.group' } | Select-Object -ExpandProperty DisplayName

    # Create a new object to store user properties
    $userObject = [PSCustomObject]@{}

    # Loop through all properties and add them to the object
    foreach ($property in $user.PSObject.Properties) {
        $value = $property.Value

        # Format all date values as "dd-MM-yyyy"
        if ($value -is [datetime]) {
            $value = $value.ToString("dd-MM-yyyy")
        }

        # Add property to the object
        $userObject | Add-Member -MemberType NoteProperty -Name $property.Name -Value $value
    }

    # Add group memberships as a comma-separated list
    $userObject | Add-Member -MemberType NoteProperty -Name "Groups" -Value ($groups -join ", ")

    # Add to data array
    $userData += $userObject
}

# Export the user data to a CSV file
$csvPath = ".\All_Users_MicrosoftGraph_All_Properties.csv"
$userData | Export-Csv -Path $csvPath -NoTypeInformation

# Append total count and timestamp to the CSV file
$totalCount = $userData.Count
$timestamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
"Total User Count: $totalCount" | Out-File -Append -FilePath $csvPath
"Execution Timestamp: $timestamp" | Out-File -Append -FilePath $csvPath

# Output the CSV file location
Write-Host "CSV file has been created at: $csvPath"
