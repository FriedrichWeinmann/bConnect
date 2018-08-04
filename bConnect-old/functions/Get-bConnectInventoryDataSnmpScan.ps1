<#
	.Synopsis
		Get SNMP scans.
	
	.DESCRIPTION
		A detailed description of the Get-bConnectInventoryDataSnmpScan function.
	
	.Parameter EndpointGuid
		Valid GUID of a endpoint.
	
	.Outputs
		Inventory (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
function Get-bConnectInventoryDataSnmpScan {
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$EndpointGuid
	)
	
	$_connectVersion = Get-bConnectVersion
	If ($_connectVersion -ge "1.0") {
		If ($EndpointGuid) {
			$_body = @{
				EndpointId = $EndpointGuid
			}
		}
		
		return Invoke-bConnectGet -Controller "InventoryDataSnmpScans" -Data $_body
	}
	else {
		return $false
	}
}