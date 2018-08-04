<#
	.Synopsis
		Get app inventory data for mobile endpoints.
	
	.DESCRIPTION
		A detailed description of the Get-bConnectInventoryAppScan function.
	
	.Parameter EndpointGuid
		Valid GUID of a endpoint.
	
	.Outputs
		InventoryApp (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
function Get-bConnectInventoryAppScan {
	param
	(
		[Parameter(Mandatory = $false,
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
		
		return Invoke-bConnectGet -Controller "InventoryAppScans" -Data $_body
	}
	else {
		return $false
	}
}