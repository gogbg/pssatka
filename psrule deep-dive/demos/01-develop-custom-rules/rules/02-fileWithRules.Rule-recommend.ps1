# https://microsoft.github.io/PSRule/v2/keywords/PSRule/en-US/about_PSRule_Keywords/#recommend


Rule 'User.enabled' -If {$TargetObject.type -eq 'user'} {
  Recommend 'Users should be enabled'
  $TargetObject.enabled
} 

Rule 'Group.NotEmpty' -If {$TargetObject.type -eq 'group'} {
  Recommend 'Groups should have members'
  $targetObject.members.count -gt 0
}
