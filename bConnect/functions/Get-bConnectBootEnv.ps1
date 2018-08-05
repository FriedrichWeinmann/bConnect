Function Get-bConnectBootEnv
{
<#
	.SYNOPSIS
		Get specified BootEnvironment or a list of all boot environments
	
	.DESCRIPTION
		Get specified BootEnvironment or a list of all boot environments
	
	.PARAMETER BootEnvironmentGuid
		Valid GUID of a boot environment
	
	.OUTPUTS
		Array of BootEnvironment (see bConnect documentation for more details)
#>
	
	Param (
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Faild to parse input as guid: {0}')]
		[string]
		$BootEnvironmentGuid
	)
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{ }
		if ($BootEnvironmentGuid) { $body['Id'] = $BootEnvironmentGuid }
		
		Invoke-bConnectGet -Controller "BootEnvironment" -Data $body | Select-PSFObject  "ID as BootEnvironmentGuid", * | ForEach-Object {
			if ($_.PSObject.Properties.Name -contains 'ID')
			{
				Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.BootEnvironment'
			}
			else
			{
				$_
			}
		}
	}
}