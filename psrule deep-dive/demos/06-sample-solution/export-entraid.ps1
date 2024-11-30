$exportFolder = Join-Path -Path $PSScriptRoot -ChildPath 'export' -AdditionalChildPath 'entraid'
if (-not (Test-Path -Path $exportFolder))
{
    New-Item -Path $exportFolder -ItemType Directory
}

Install-PSResource -RequiredResource @{
  'EntraExporter' = @{
    Version    = '2.0.7'
    Repository = 'PSGallery'
  }
} -Quiet -AcceptLicense -Scope CurrentUser -TrustRepository -ErrorAction Stop

$token = Get-AzAccessToken -ResourceTypeName MSGraph
Connect-MgGraph -AccessToken ($token.Token | ConvertTo-SecureString -AsPlainText)
Export-Entra -Path $exportFolder -Type Users