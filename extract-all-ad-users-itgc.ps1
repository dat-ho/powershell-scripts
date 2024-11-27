# Import the Active Directory module
Import-Module ActiveDirectory

# Automatically detect the domain DN for the SearchBase and domain name for the file name
$domainInfo = Get-ADDomain
$searchBase = $domainInfo.DistinguishedName
$domainName = $domainInfo.Name

# Get all active users with additional properties and dynamically set SearchBase
$users = Get-ADUser -SearchBase $searchBase -Properties canonicalname, Enabled, DistinguishedName, EmployeeID, EmployeeNumber, SamAccountName, Name, GivenName, Initials, Surname, DisplayName, Title, EmailAddress, Description, Department, Company, CannotChangePassword, PasswordNeverExpires, PasswordNotRequired, LockedOut, AccountExpirationDate, LastLogonDate, PasswordLastSet, whenCreated, lastLogonTimestamp, msDS-UserPasswordExpiryTimeComputed, whenChanged, MemberOf

# Array to store the user data
$userData = @()

# Loop through each user and extract the required information
foreach ($user in $users) {
    # Convert group memberships
    $groups = $user.MemberOf | ForEach-Object { (Get-ADGroup -Identity $_ -Properties Name).Name }

    $userData += [PSCustomObject]@{
        OU = ($user.canonicalname -Split "/")[-2]
        Enabled = $user.Enabled
        DistinguishedName = $user.DistinguishedName
        EmployeeID = $user.EmployeeID
        EmployeeNumber = $user.EmployeeNumber
        LogonAccount = $user.SamAccountName
        AccountName = $user.Name
        GivenName = $user.GivenName
        Initials = $user.Initials
        Surname = $user.Surname
        DisplayName = $user.DisplayName
        Title = $user.Title
        Email = $user.EmailAddress
        Description = $user.Description
        Department = $user.Department
        Company = $user.Company
        CannotChangePassword = $user.CannotChangePassword
        PasswordNeverExpires = $user.PasswordNeverExpires
        PasswordNotRequired = $user.PasswordNotRequired
        LockedOut = $user.LockedOut
        ExpiryDate = if ($user.AccountExpirationDate) { ($user.AccountExpirationDate).ToString("dd-MM-yyyy") } else { "" }
        LastLogon = if ($user.LastLogonDate) { ($user.LastLogonDate).ToString("dd-MM-yyyy") } else { "" }
        PasswordLastSet = if ($user.PasswordLastSet) { ($user.PasswordLastSet).ToString("dd-MM-yyyy") } else { "" }
        CreatedDate = if ($user.WhenCreated) { ($user.WhenCreated).ToString("dd-MM-yyyy") } else { "" }
        #LastLogonTimestamp = if ($user.lastLogonTimestamp) { [DateTime]::FromFileTime($user.lastLogonTimestamp).ToString("dd-MM-yyyy") } else { "" }
        #PasswordExpiryDate = if ($user."msDS-UserPasswordExpiryTimeComputed") { [DateTime]::FromFileTime($user."msDS-UserPasswordExpiryTimeComputed").ToString("dd-MM-yyyy") } else { "" }
        whenChanged = if ($user.whenChanged) { ($user.whenChanged).ToString("dd-MM-yyyy") } else { "" }
        Groups = $groups -join ", "
    }
}

# Export the user data to a CSV file with the detected domain name
$csvPath = ".\All_Users_$domainName.csv"
$userData | Export-Csv -Path $csvPath -NoTypeInformation

# Add total count and timestamp to the CSV file
$totalCount = $userData.Count
$timestamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
"Total User Count: $totalCount" | Out-File -Append -FilePath $csvPath
"Execution Timestamp: $timestamp" | Out-File -Append -FilePath $csvPath

# Output the CSV file location
Write-Host "CSV file has been created at: $csvPath"
