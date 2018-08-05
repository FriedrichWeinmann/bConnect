function Resume-bConnectJobInstance
{
<#
	.SYNOPSIS
		Resume the specified jobinstance.
	
	.DESCRIPTION
		Resume the specified jobinstance.
	
	.PARAMETER JobInstanceGuid
		Valid GUID of a jobinstance.
#>
	[CmdletBinding()]
	param (
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$JobInstanceGuid
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{
			Id  = $JobInstanceGuid
			Cmd = "resume"
		}
		
		Invoke-bConnectGet -Controller "JobInstances" -Data $body
	}
}