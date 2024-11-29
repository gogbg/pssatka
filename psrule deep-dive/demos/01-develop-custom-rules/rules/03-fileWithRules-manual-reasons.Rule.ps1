# https://microsoft.github.io/PSRule/v2/keywords/PSRule/en-US/about_PSRule_Keywords/#reason

Rule 'User.enabled' -If { $TargetObject.type -eq 'user' } {
  Recommend 'Users should be enabled'
  reason "Property enabled should be true, and is: $($TargetObject.enabled)" #manually setting the reason, in all cases!
  $TargetObject.enabled
} 

Rule 'Group.NotEmpty' -If {$TargetObject.type -eq 'group'} {
  Recommend 'Groups should have members'

  #if we want to set the reason/recommend only when condition is not met
  if ($targetObject.members.count -gt 0)
  {
    $true #mark the assessed object as passed
  }
  else
  {
    reason "Property members should be => 0, but is: $($TargetObject.members.count)" #manually setting the reason, only when condition is not met!
    $false #mark the assessed object as failed
  }
}
