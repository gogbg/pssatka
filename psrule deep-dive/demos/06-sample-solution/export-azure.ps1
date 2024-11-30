$azureDataFolder = Join-Path -Path $PSScriptRoot -ChildPath 'export' -AdditionalChildPath 'azure'
if (-not (Test-Path -Path $azureDataFolder))
{
    New-Item -Path $azureDataFolder -ItemType Directory
}
Export-AzRuleData -OutputPath $azureDataFolder -Subscription '88e64586-f51c-4e13-9307-c97f28464675' -Tenant '098ebab6-0ca3-4735-973c-7e8b14e101ac'