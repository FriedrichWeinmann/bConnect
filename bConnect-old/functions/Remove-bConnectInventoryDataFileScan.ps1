Function Remove-bConnectInventoryDataFileScan() {
    <#
        .Synopsis
            Remove all file scans from specified endpoint.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            Bool
    #>
	[CmdletBinding(SupportsShouldProcess = $true)]
	Param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]	
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$EndpointGuid
	)
	
	$_connectVersion = Get-bConnectVersion
	If ($_connectVersion -ge "1.0") {
		$_body = @{
			EndpointId    = $EndpointGuid;
		}
		
		if ($pscmdlet.ShouldProcess($EndpointGuid, "Remove InventoryDataFileScan")) {
			return Invoke-bConnectDelete -Controller "InventoryDataFileScans" -Data $_body
		}
	}
	else {
		return $false
	}
}