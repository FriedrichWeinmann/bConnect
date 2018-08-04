<#
	.Synopsis
		Get specified endpoint or all endpoints in given OrgUnit
	
	.DESCRIPTION
		Get specified endpoint or all endpoints in given OrgUnit. You can get the Endpoint by GUID from a Endpoint, a OrgUnit, a StaticGroup or a DynamicGroup
	
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
	
	.Outputs
		Array of Endpoint (see bConnect documentation for more details)
	
	.NOTES
		Additional information about the function.
#>
function Get-bConnectEndpoint {
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$EndpointGuid,
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string]$OrgUnitGuid,
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[string]$DynamicGroupGuid,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$StaticGroupGuid,
		[switch]$PublicKey,
		[switch]$IncludeSoftware,
		[switch]$IncludeSnmpData
	)
	
	begin {
		$Test = Test-bConnect
		
		if ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			throw $ErrorObject
		}
		# Adds the Public Key to the Ouptut
		if ($PublicKey) {
			$_body += @{
				PubKey = $true
			}
		}
		# Adds the Installed Software to the Ouptut
		if ($IncludeSoftware) {
			$_body += @{
				InstalledSoftware = $true
			}
		}
		# Adds the SNMP Data to the Ouptut
		if ($IncludeSnmpData) {
			$_body += @{
				SnmpData = $true
			}
		}
	}
	process {
		$_body = @{ }
		if ($EndpointGuid) {
			$_body = @{
				Id = $EndpointGuid
			}
		}
		elseif ($OrgUnitGuid) {
			$_body = @{
				OrgUnit = $OrgUnitGuid
			}
		}
		elseif ($DynamicGroupGuid) {
			$_body = @{
				DynamicGroup = $DynamicGroupGuid
			}
		}
		elseif ($StaticGroupGuid) {
			$_body = @{
				StaticGroup = $StaticGroupGuid
			}
		}
		$Result = Invoke-bConnectGet -Controller "Endpoints" -Data $_body | Select-Object  @{ Name = "EndpointGuid"; Expression = { $_.ID } }, *
		$Result | ForEach-Object {
			if ($_.PSObject.Properties.Name -contains 'ID') {
				Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.Endpoint'
			}
			else {
				$_
			}
		}
	}
}