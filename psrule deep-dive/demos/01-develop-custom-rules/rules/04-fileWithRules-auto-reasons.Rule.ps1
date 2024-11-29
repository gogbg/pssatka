# https://microsoft.github.io/PSRule/v2/concepts/PSRule/en-US/about_PSRule_Assert/

Rule 'User.enabled' -If {

  $TargetObject.type -eq 'user'
  } {
  Recommend 'Users should be enabled'
  $Assert.HasFieldValue($TargetObject, 'enabled', $true) # auto setting the reason, if condition is not met

} 

Rule 'Group.NotEmpty' -If {

  $TargetObject.type -eq 'group'
  } {
  Recommend 'Groups should have members'
  $Assert.GreaterOrEqual($TargetObject,'members',0) # auto setting the reason, if condition is not met

}
