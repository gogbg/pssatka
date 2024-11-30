Rule 'resourceGroup.OwnerTag' -if { $TargetObject.type -eq 'Microsoft.Resources/resourceGroups' } {
  $Assert.Contains($TargetObject, 'tags', 'owner')
}


Rule 'resourceGroup.ShouldHaveValidOwner' -if {
  $TargetObject.type -eq 'Microsoft.Resources/resourceGroups' -and
  $TargetObject.tags -and
  $TargetObject.tags.ContainsKey('owner') 
} {
  $userResolver = $PSRule.GetService('userResolver')
  if ($userResolver.ContainsUser($TargetObject.tags.owner))
  {
    $true
  }
  else
  {
    reason "Users with upn: '$($TargetObject.tags.owner)' not found"
    $PSRule.Data['InvalidOwners'] = $TargetObject.tags.owner
    $false
  }
}