# https://microsoft.github.io/PSRule/v2/keywords/PSRule/en-US/about_PSRule_Keywords/#rule

# https://microsoft.github.io/PSRule/v2/concepts/PSRule/en-US/about_PSRule_Selectors/

Rule 'User.enabled' -If {$TargetObject.type -eq 'user'} {
  #return true if object is compliant or false if not
  $TargetObject.enabled
} 

Rule 'Group.NotEmpty' -If {$TargetObject.type -eq 'group'} {
  #return true if object is compliant or false if not
  $targetObject.members.count -gt 0
}
