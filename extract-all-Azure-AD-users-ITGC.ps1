#As of March 30, 2024, Azure AD, Azure AD Preview, and MS Online PowerShell modules are deprecated.
# Install the AzureAD module if not installed
if (-not (Get-Module -ListAvailable -Name AzureAD)) {
    Install-Module -Name AzureAD -AllowClobber -Force -Verbose
}

# Import the module
Import-Module AzureAD

# Prompt for Admin Credentials
$Credential = Get-Credential

# Connect to Azure AD using provided credentials
Connect-AzureAD -Credential $Credential

# Get all Azure AD users with all available properties
$users = Get-AzureADUser -All $true | Select-Object -Property *

# Array to store user data
$userData = @()

# Loop through each user and extract all properties
foreach ($user in $users) {
    # Get group memberships for the user
    $groups = Get-AzureADUserMembership -ObjectId $user.ObjectId | Where-Object { $_.ObjectType -eq "Group" } | Select-Object -ExpandProperty DisplayName

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

    # Add group memberships separately
    $userObject | Add-Member -MemberType NoteProperty -Name "Groups" -Value ($groups -join ", ")

    # Add to data array
    $userData += $userObject
}

# Export the user data to a CSV file
$csvPath = ".\All_Users_AzureAD_All_Properties.csv"
$userData | Export-Csv -Path $csvPath -NoTypeInformation

# Append total count and timestamp to the CSV file
$totalCount = $userData.Count
$timestamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
"Total User Count: $totalCount" | Out-File -Append -FilePath $csvPath
"Execution Timestamp: $timestamp" | Out-File -Append -FilePath $csvPath

# Output the CSV file location
Write-Host "CSV file has been created at: $csvPath"
