function Get-bConnectInventoryAppScan
{
<#
	.SYNOPSIS
		Get app inventory data for mobile endpoints.
	
	.DESCRIPTION
		Get app inventory data for mobile endpoints.
	
	.PARAMETER EndpointGuid
		Valid GUID of a endpoint.
#>
	[CmdletBinding()]
	param
	(
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
		if ($EndpointGuid) { $body['EndpontId'] = $EndpointGuid }
		
		Invoke-bConnectGet -Controller "InventoryAppScans" -Data $body
	}
}