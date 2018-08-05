function Remove-bConnectApplication
{
<#
	.SYNOPSIS
		Remove specified application.
	
	.DESCRIPTION
		Remove specified application.
	
	.PARAMETER ApplicationGuid
		Valid GUID of a application.
	
	.PARAMETER Application
		Valid Application object
#>
	[CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'AppID')]
	param (
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'AppID')]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$ApplicationGuid,
		
		[Parameter(Mandatory = $true, ParameterSetName = 'App')]
		[PSCustomObject]
		$Application
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		if ($ApplicationGuid)
		{
			$body = @{
				Id = $ApplicationGuid
			}
		}
		else
		{
			$body = @{
				Id = $Application.Id
			}
		}
		
		if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $ApplicationGuid -Action 'Remove-Application')
		{
			Invoke-bConnectDelete -Controller "Applications" -Data $body
		}
	}
}