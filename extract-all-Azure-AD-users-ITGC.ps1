# Import the Azure AD module
Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Get all Azure AD users with additional properties
$users = Get-AzureADUser -All $true | Select-Object -Property *

# Array to store the user data
$userData = @()

# Loop through each user and extract the required information
foreach ($user in $users) {
    # Get group memberships for the user
    $groups = Get-AzureADUserMembership -ObjectId $user.ObjectId | Where-Object { $_.ObjectType -eq "Group" } | Select-Object -ExpandProperty DisplayName

    $userData += [PSCustomObject]@{
        OU = "Azure AD"  # Azure AD doesn't have OUs, so we set a placeholder
        Enabled = $user.AccountEnabled
        #DistinguishedName = $user.UserPrincipalName  # Azure AD doesn't have DistinguishedName, so we use UPN
        EmployeeID = $user.EmployeeId
        #EmployeeNumber = $user.EmployeeId  # Azure AD doesn't have EmployeeNumber, so we use EmployeeId
        LogonAccount = $user.UserPrincipalName
        AccountName = $user.DisplayName
        GivenName = $user.GivenName
        #Initials = ""  # Azure AD doesn't have Initials
        Surname = $user.Surname
        DisplayName = $user.DisplayName
        Title = $user.JobTitle
        Email = $user.Mail
        Description = $user.Description
        Department = $user.Department
        Company = $user.CompanyName
        #CannotChangePassword = $null  # Azure AD doesn't have this property
        #PasswordNeverExpires = $null  # Azure AD doesn't have this property
        #PasswordNotRequired = $null  # Azure AD doesn't have this property
        #LockedOut = $null  # Azure AD doesn't have this property
        ExpiryDate = if ($user.AccountExpirationDate) { ($user.AccountExpirationDate).ToString("dd-MM-yyyy") } else { "" }
        LastLogon = if ($user.LastPasswordChangeDateTime) { ($user.LastPasswordChangeDateTime).ToString("dd-MM-yyyy") } else { "" }
        PasswordLastSet = if ($user.LastPasswordChangeDateTime) { ($user.LastPasswordChangeDateTime).ToString("dd-MM-yyyy") } else { "" }
        CreatedDate = if ($user.CreationType) { ($user.CreationType).ToString("dd-MM-yyyy") } else { "" }  # Azure AD doesn't have WhenCreated
        whenChanged = if ($user.RefreshTokensValidFromDateTime) { ($user.RefreshTokensValidFromDateTime).ToString("dd-MM-yyyy") } else { "" }
        Groups = $groups -join ", "
    }
}

# Export the user data to a CSV file
$csvPath = ".\All_Users_AzureAD.csv"
$userData | Export-Csv -Path $csvPath -NoTypeInformation

# Add total count and timestamp to the CSV file
$totalCount = $userData.Count
$timestamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
"Total User Count: $totalCount" | Out-File -Append -FilePath $csvPath
"Execution Timestamp: $timestamp" | Out-File -Append -FilePath $csvPath

# Output the CSV file location
Write-Host "CSV file has been created at: $csvPath"
