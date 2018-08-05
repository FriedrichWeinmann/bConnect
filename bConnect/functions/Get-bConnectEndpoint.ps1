function Get-bConnectEndpoint
{
<#
	.Synopsis
		Get specified endpoint or all endpoints in given OrgUnit
	
	.DESCRIPTION
		Get specified endpoint or all endpoints in given OrgUnit.
		You can get the Endpoint by GUID from a Endpoint, a OrgUnit, a StaticGroup or a DynamicGroup
	
	.Parameter EndpointGuid
		Valid GUID of a endpoint
	
	.Parameter OrgUnitGuid
		Valid GUID of a Orgunit
	
	.PARAMETER DynamicGroupGuid
		Valid GUID of a DynamicGroup
	
	.PARAMETER StaticGroupGuid
		Valid GUID of a DynamicGroup
	
	.PARAMETER PublicKey
		When Activated the Public Key of the Endpoint is added to the Ouput
	
	.PARAMETER IncludeSoftware
		When Activated the Installed Software of the Endpoint is added to the Ouput
	
	.PARAMETER IncludeSnmpData
		When Activated the SNMP Data of the Endpoint is added to the Ouput
	
	.EXAMPLE
		PS C:\> Get-bConnectEndpoint
		
		Lists all Endpoints from the Baramundi Management Suite
	
	.EXAMPLE
		PS C:\> Get-bConnectEndpoint -EndpointGuid 00BE8A60-B84B-4545-A12B-3F1AB3192407
		
		Lists only the Endpoint with the GUID 00BE8A60-B84B-4545-A12B-3F1AB3192407
	
	.EXAMPLE
		PS C:\> Get-bConnectEndpoint -EndpointGuid 00BE8A60-B84B-4545-A12B-3F1AB3192407 -IncludeSoftware -PublicKey
		
		Lists only the Endpoint with the GUID 00BE8A60-B84B-4545-A12B-3F1AB3192407,
		also includes the Installed Software through BMS of the Endpoint and the Public Key of the Endpoint
	
	.EXAMPLE
		PS C:\> Get-bConnectEndpoint -OrgUnitGuid 02AE4160-B84B-4545-A12B-3F1AB3192407
		
		Lists only the Endpoint with the GUID 02AE4160-B84B-4545-A12B-3F1AB3192407
	
	.OUTPUTS
		bConnect.Endpoint[]
	
	.NOTES
		Additional information about the function.
#>
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$EndpointGuid,
		
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string]
		$OrgUnitGuid,
		
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string]
		$DynamicGroupGuid,
		
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$StaticGroupGuid,
		
		[switch]
		$PublicKey,
		
		[switch]
		$IncludeSoftware,
		
		[switch]
		$IncludeSnmpData
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{ }
		
		if ($EndpointGuid) { $body["Id"] = $EndpointGuid }
		elseif ($OrgUnitGuid){ $body["OrgUnit"] = $OrgUnitGuid }
		elseif ($DynamicGroupGuid) { $body["DynamicGroup"] = $DynamicGroupGuid }
		elseif ($StaticGroupGuid) { $body["StaticGroup"] = $StaticGroupGuid }
		
		# Adds the Public Key to the Ouptut
		if ($PublicKey) { $body["PubKey"] = $true }
		
		# Adds the Installed Software to the Ouptut
		if ($IncludeSoftware) { $body["InstalledSoftware"] = $true }
		
		# Adds the SNMP Data to the Ouptut
		if ($IncludeSnmpData) { $body["SnmpData"] = $true }
		
		Invoke-bConnectGet -Controller "Endpoints" -Data $body |
		Select-PSFObject "ID as EndpointGuid", "*" |
		Add-ObjectDetail -TypeName 'bConnect.Endpoint' -WithID
	}
}