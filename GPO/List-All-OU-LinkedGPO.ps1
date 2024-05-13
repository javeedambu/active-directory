
# List all OUs
$allOUs = Get-ADOrganizationalUnit -Filter *

# List all linked GPOs on each OU
$allOUGPOs = foreach ($ou in $allOUs) {
    Get-GPInheritance -Target $ou | Select-Object Name, ContainerType, Path,
        @{Name="GpoLinks"; Expression={$_.GpoLinks.DisplayName -join ", "}},
        @{Name="InheritedGpoLinks"; Expression={$_.InheritedGpoLinks.DisplayName -join ", "}},
        GpoInheritanceBlocked
}


# Export to CSV
$allOUGPOs | Export-Csv -Path ".\GPO\All_OUs_$(Get-Date -Format yyyy-MM-dd-HHmmss).csv" -NoTypeInformation
