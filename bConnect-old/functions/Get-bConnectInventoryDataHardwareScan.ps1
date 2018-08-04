<#
	.Synopsis
		Get Hardware scans.
	
	.DESCRIPTION
		A detailed description of the Get-bConnectInventoryDataHardwareScan function.
	
	.Parameter EndpointGuid
		Valid GUID of a endpoint.
	
	.Parameter TemplateName
		Valid name of a inventory template
	
	.Parameter ScanTerm
		"latest" or specified as UTC time in the format "yyyy-MM-ddThh:mm:ssZ" (y=year, M=month, d=day, h=hours, m=minutes, s=seconds).
	
	.Outputs
		Inventory (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
function Get-bConnectInventoryDataHardwareScan {
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$EndpointGuid,
		[string]$TemplateName,
		[string]$ScanTerm
	)
	
	$_connectVersion = Get-bConnectVersion
	If ($_connectVersion -ge "1.0") {
		$_body = @{ }
		If ($EndpointGuid) {
			$_body += @{ EndpointId = $EndpointGuid }
		}
		If ($TemplateName) {
			$_body += @{ TemplateName = $TemplateName }
		}
		If ($ScanTerm) {
			$_body += @{ Scan = $ScanTerm }
		}
		
		return Invoke-bConnectGet -Controller "InventoryDataHardwareScans" -Data $_body
	}
	else {
		return $false
	}
}