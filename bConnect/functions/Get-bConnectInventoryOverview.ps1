Function Get-bConnectInventoryOverview
{
<#
	.SYNOPSIS
		Get overview over all inventory scans.
	
	.DESCRIPTION
		Get overview over all inventory scans.
	
	.PARAMETER EndpointGuid
		Valid GUID of a endpoint.
#>
	[CmdletBinding()]
	Param (
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
		if ($EndpointGuid) { $body['EndpointId'] = $EndpointGuid }
		
		Invoke-bConnectGet -Controller "InventoryOverviews" -Data $body
	}
}