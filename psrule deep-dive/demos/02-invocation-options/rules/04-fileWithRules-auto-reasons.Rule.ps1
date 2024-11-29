# https://microsoft.github.io/PSRule/v2/concepts/PSRule/en-US/about_PSRule_Options/#options

Rule 'User.enabled' -Type user {
  Recommend 'Users should be enabled'
  $Assert.HasFieldValue($TargetObject, 'enabled', $true) # auto setting the reason, if condition is not met
} 

Rule 'Group.NotEmpty' -type group {
  Recommend 'Groups should have members'
  $Assert.GreaterOrEqual($TargetObject,'members',0) # auto setting the reason, if condition is not met
}
