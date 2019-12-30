$cred = Get-Credential

Configuration DSCFromGPO
{

	Import-DSCResource -ModuleName 'PSDesiredStateConfiguration' -ModuleVersion 1.1
	#Import-DSCResource -ModuleName 'AuditPolicyDSC' -ModuleVersion 1.4.0.0
     Import-DSCResource -ModuleName 'SecurityPolicyDSC' -ModuleVersion 2.9.0.0
     Import-DscResource -ModuleName 'xPSDesiredStateConfiguration' -ModuleVersion 8.10.0.0
	# Module Not Found: Import-DSCResource -ModuleName 'PowerShellAccessControl'
	Node localhost
	{
         AccountPolicy 'SecuritySetting(INF): ResetLockoutCount'
         {
              Reset_account_lockout_counter_after = 15
              Name = 'Reset_account_lockout_counter_after'

         }

         AccountPolicy 'SecuritySetting(INF): MinimumPasswordAge'
         {
              Minimum_Password_Age = 1
              Name = 'Minimum_Password_Age'

         }

         AccountPolicy 'SecuritySetting(INF): MaximumPasswordAge'
         {
              Name = 'Maximum_Password_Age'
              Maximum_Password_Age = 60

         }

         AccountPolicy 'SecuritySetting(INF): LockoutBadCount'
         {
              Name = 'Account_lockout_threshold'
              Account_lockout_threshold = 10

         }

         AccountPolicy 'SecuritySetting(INF): PasswordComplexity'
         {
              Name = 'Password_must_meet_complexity_requirements'
              Password_must_meet_complexity_requirements = 'Enabled'

         }

         AccountPolicy 'SecuritySetting(INF): LockoutDuration'
         {
              Name = 'Account_lockout_duration'
              Account_lockout_duration = 15

         }

         AccountPolicy 'SecuritySetting(INF): PasswordHistorySize'
         {
              Name = 'Enforce_password_history'
              Enforce_password_history = 24

         }

         AccountPolicy 'SecuritySetting(INF): ClearTextPassword'
         {
              Name = 'Store_passwords_using_reversible_encryption'
              Store_passwords_using_reversible_encryption = 'Disabled'

         }

         AccountPolicy 'SecuritySetting(INF): MinimumPasswordLength'
         {
              Name = 'Minimum_Password_Length'
              Minimum_Password_Length = 14

         }

         xUser LocalUser
          {
               UserName = 'testuser'
               Disabled = $false
               Ensure = 'Present'
               FullName = 'Test User'
               #Password = $cred
               PasswordChangeNotAllowed = $false
               PasswordChangeRequired = $false
               PasswordNeverExpires = $false
          }
	}
}

DSCFromGPO -OutputPath C:\Repo\Seelive-Channel\Mofs
