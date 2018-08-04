Function Remove-bConnectApplication() {
    <#
        .Synopsis
            Remove specified application.
        .Parameter ApplicationGuid
            Valid GUID of a application.
        .Parameter Application
            Valid Application object
        .Outputs
            Bool
    #>
	[CmdletBinding(SupportsShouldProcess = $true)]
	Param (
		[Parameter(ValueFromPipelineByPropertyName = $true)]	
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$ApplicationGuid,
		[PSCustomObject]$Application
	)
	
	$_connectVersion = Get-bConnectVersion
	If ($_connectVersion -ge "1.0") {
		If (![string]::IsNullOrEmpty($ApplicationGuid)) {
			$_body = @{
				Id    = $ApplicationGuid
			}
		}
		elseif (![string]::IsNullOrEmpty($Application.Id)) {
			$_body = @{
				Id    = $Application.Id
			}
		}
		else {
			return $false
		}
		if ($pscmdlet.ShouldProcess($ApplicationGuid, "Remove Application")) {
			return Invoke-bConnectDelete -Controller "Applications" -Data $_body
		}
	}
	else {
		return $false
	}
}