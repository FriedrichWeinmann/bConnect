function Get-bConnectInventoryDataHardwareScan
{
<#
	.SYNOPSIS
		Get Hardware scans.
	
	.DESCRIPTION
		Get Hardware scans.
	
	.PARAMETER EndpointGuid
		Valid GUID of a endpoint.
	
	.PARAMETER TemplateName
		Valid name of a inventory template
	
	.PARAMETER ScanTerm
		"latest" or specified as UTC time in the format "yyyy-MM-ddThh:mm:ssZ" (y=year, M=month, d=day, h=hours, m=minutes, s=seconds).
#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$EndpointGuid,
		
		[string]
		$TemplateName,
		
		[string]
		$ScanTerm
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{ }
		if ($EndpointGuid) { $body['EndpointId'] = $EndpointGuid }
		if ($TemplateName) { $body['TemplateName'] = $TemplateName }
		if ($ScanTerm) { $body['Scan'] = $ScanTerm }
		
		Invoke-bConnectGet -Controller "InventoryDataHardwareScans" -Data $body
	}
}