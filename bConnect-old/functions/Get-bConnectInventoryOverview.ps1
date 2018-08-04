Function Get-bConnectInventoryOverview() {
    <#
        .Synopsis
            Get overview over all inventory scans.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Outputs
            InventoryOverview (see bConnect documentation for more details).
    #>
	
	Param (
		[Parameter(ValueFromPipelineByPropertyName = $true)]	
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$EndpointGuid
	)
	
	$_connectVersion = Get-bConnectVersion
	If ($_connectVersion -ge "1.0") {
		If ($EndpointGuid) {
			$_body = @{
				EndpointId    = $EndpointGuid
			}
		}
		
		return Invoke-bConnectGet -Controller "InventoryOverviews" -Data $_body
	}
	else {
		return $false
	}
}