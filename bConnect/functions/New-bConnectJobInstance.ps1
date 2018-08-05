function New-bConnectJobInstance
{
<#
	.SYNOPSIS
		Assign the specified job to a endpoint.
	
	.DESCRIPTION
		Assign the specified job to a endpoint.
	
	.PARAMETER EndpointGuid
		Valid GUID of a endpoint.
	
	.PARAMETER JobGuid
		Valid GUID of a job.
	
	.Parameter StartIfExists
		Restart the existing jobinstance if there is one.
#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$EndpointGuid,
		
		[Parameter(Mandatory = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$JobGuid,
		
		[switch]
		$StartIfExists
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{
			EndpointId    = $EndpointGuid;
			JobId		  = $JobGuid;
			StartIfExists = $StartIfExists.ToString()
		}
		
		Invoke-bConnectGet -Controller "JobInstances" -Data $body
	}
}