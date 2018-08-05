<#
	.Synopsis
		Remove all registry scans from specified endpoint.
	
	.DESCRIPTION
		A detailed description of the Remove-bConnectInventoryDataRegistryScan function.
	
	.Parameter EndpointGuid
		Valid GUID of a endpoint.
	
	.Outputs
		Bool
	
	.NOTES
		Additional information about the function.
#>
function Remove-bConnectInventoryDataRegistryScan {
	[CmdletBinding(SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$EndpointGuid
	)
	
	$_connectVersion = Get-bConnectVersion
	If ($_connectVersion -ge "1.0") {
		$_body = @{
			EndpointId	   = $EndpointGuid;
		}
		if ($pscmdlet.ShouldProcess($EndpointGuid, "Remove InventoryDataRegistryScan")) {
			return Invoke-bConnectDelete -Controller "InventoryDataRegistryScans" -Data $_body
		}
	}
	else {
		return $false
	}
}
