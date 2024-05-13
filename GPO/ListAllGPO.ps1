# List All GPOs
Get-GPO -All `
  | Select-Object DisplayName,Id,Description,GpoStatus,DomainName,WmiFilter `
  | Export-Csv -Path ".\GPOs_$(Get-Date -format yyyy-MM-dd-HHmmss).csv" -NoTypeInformation
