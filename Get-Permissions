<#
.DESCRIPTION
    This script recursively gets the permissions of files and folders under a specified directory
    and exports the results to a CSV file.
.NOTES
    File Name: Get-Permissions.ps1
    Author   : Dat Ho
    Date     : 23 Feb 2024
    Version  : 1.0
#>

param (
    # Defines parameters for the script.
    
    [string]$DirectoryPath = "C:\Your\Directory\Path",
    # Specifies the directory path to analyse permissions.
    # Defaults to "C:\Your\Directory\Path" if not provided.
    
    [string]$ExportPath = "C:\Your\Export\Path\Permissions.csv"
    # Specifies the export path for the CSV file containing permissions.
    # Defaults to "C:\Your\Export\Path\Permissions.csv" if not provided.
)

# Function to recursively get permissions of folders and files
function Get-Permissions {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )
    
    Get-ChildItem -Path $Path -Recurse |
    ForEach-Object {
        $Item = $_
        $Acl = Get-Acl -Path $Item.FullName
        foreach ($Access in $Acl.Access) {
            [PSCustomObject]@{
                Path = $Item.FullName
                FileSystemRights = $Access.FileSystemRights
                AccessControlType = $Access.AccessControlType
                IdentityReference = $Access.IdentityReference
                IsInherited = $Access.IsInherited
                InheritanceFlags = $Access.InheritanceFlags
                PropagationFlags = $Access.PropagationFlags
                AuditFlags = $Access.AuditFlags
            }
        }
    }
}

# Get permissions recursively
$Permissions = Get-Permissions -Path $DirectoryPath

# Export to CSV
$Permissions | Export-Csv -Path $ExportPath -NoTypeInformation


<# 
README - DAT HO

FileSystemRights: This property represents the specific rights granted or denied to the user or group. It includes permissions like Read, Write, Execute, Modify, Full Control, etc. These rights determine what actions can be performed on the file or folder.

AccessControlType: This property specifies whether the permission is an Allow or Deny permission. An Allow permission grants access to a user or group, while a Deny permission explicitly denies access.

IdentityReference: This property indicates the user or group to which the permission applies. It specifies the security principal (user or group account) to which the access control entry (ACE) applies.

IsInherited: This property indicates whether the permission is inherited from a parent object (such as a folder higher in the directory tree) or if it is explicitly set on the current object. If it's inherited, it will be True; otherwise, it will be False.

InheritanceFlags: This property specifies how permissions are inherited by child objects. It defines whether the permissions are inherited only by child objects (and not by the object's own children), or if they are inherited by both the object's children and its own children's children. This can have values such as None, ContainerInherit, ObjectInherit, etc.

PropagationFlags: This property specifies how inherited permissions are propagated to child objects. It determines whether the permissions are automatically applied to child objects when they are created, or if they need to be manually applied. Values may include None, NoPropagateInherit, InheritOnly, etc.

AuditFlags: This property specifies whether auditing is enabled for the particular access control entry (ACE). Auditing allows you to track who accesses or modifies the file or folder. This property indicates what types of access attempts will be audited, such as Success, Failure, etc.
#>
