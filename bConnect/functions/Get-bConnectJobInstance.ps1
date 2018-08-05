function Get-bConnectJobInstance
{
<#
	.SYNOPSIS
		Get specified jobinstance by GUID, all jobinstances of a job or all jobinstances on a endpoint.
	
	.DESCRIPTION
		Get specified jobinstance by GUID, all jobinstances of a job or all jobinstances on a endpoint.
	
	.PARAMETER JobInstanceGuid
		Valid GUID of a jobinstance.
	
	.PARAMETER JobGuid
		Valid GUID of a job.
	
	.PARAMETER EndpointGuid
		Valid GUID of a endpoint
#>
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$JobInstanceGuid,
		
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$JobGuid,
		
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$EndpointGuid
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{ }
		if ($JobGuid) { $body['JobId'] = $JobGuid }
		if ($EndpointGuid) { $body['EndpointId'] = $EndpointGuid }
		if ($JobInstanceGuid) { $body['Id'] = $JobInstanceGuid }
		
		Invoke-bConnectGet -Controller "JobInstances" -Data $body
	}
}