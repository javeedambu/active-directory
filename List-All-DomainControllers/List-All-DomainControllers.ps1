# List all domain controllers in Forest
(Get-ADForest).domains `
    | ForEach-Object {Get-ADDomainController -Filter * -Server $_} `
    | select Domain,HostName,IPv4Address,@{n="OperationMasterRoles";e={$_.OperationMasterRoles -join ", "}} `
    | Ft -wrap

# Export to CSV
(Get-ADForest).domains `
    | ForEach-Object {Get-ADDomainController -Filter * -Server $_} `
    | select Domain,HostName,IPv4Address,@{n="OperationMasterRoles";e={$_.OperationMasterRoles -join ", "}} `
    | Export-Csv ".\All_DomainContollers_$(Get-Date -Format yyyy-MM-dd-HHmmss).csv" -NoTypeInformation
