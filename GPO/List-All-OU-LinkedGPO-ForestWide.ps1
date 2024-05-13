# List all OUs and their associated GPOs within the AD Forest

# Initialise variable
$ allOUGPOs = @()

# List all Domains in the Forest
$allDomains = (Get-ADForest).domains

# Iterate though each Domain
foreach ($dom in $allDomains) {

    # List linked GPOs on each Domain
    $allOUGPOs += Get-GPInheritance -Target (Get-ADDomain $dom) | Select-Object Name, ContainerType, Path,
        @{Name="GpoLinks"; Expression={$_.GpoLinks.DisplayName -join ", "}},
        @{Name="InheritedGpoLinks"; Expression={$_.InheritedGpoLinks.DisplayName -join ", "}},
        GpoInheritanceBlocked

    # List all OUs
    $allOUs = Get-ADOrganizationalUnit -Filter *


    # List all linked GPOs on each OU
    $allOUGPOs += foreach ($ou in $allOUs) {
        Get-GPInheritance -Target $ou | Select-Object Name, ContainerType, Path,
            @{Name="GpoLinks"; Expression={$_.GpoLinks.DisplayName -join ", "}},
            @{Name="InheritedGpoLinks"; Expression={$_.InheritedGpoLinks.DisplayName -join ", "}},
            GpoInheritanceBlocked
    }

}

# Export to CSV
$allOUGPOs | Export-Csv -Path ".\GPO\All_OUs_$(Get-Date -Format yyyy-MM-dd-HHmmss).csv" -NoTypeInformation
