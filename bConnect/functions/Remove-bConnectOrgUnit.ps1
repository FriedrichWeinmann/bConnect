Function Remove-bConnectOrgUnit() {
    <#
        .Synopsis
            Remove specified OrgUnit.
        .Parameter OrgUnitGuid
            Valid GUID of a OrgUnit.
        .Outputs
            Bool
    #>
	[CmdletBinding(SupportsShouldProcess = $true)]
	Param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]	
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$OrgUnitGuid
	)
	
	$_connectVersion = Get-bConnectVersion
	If ($_connectVersion -ge "1.0") {
		$_body = @{
			Id    = $OrgUnitGuid
		}
		
		if ($pscmdlet.ShouldProcess($OrgUnitGuid, "Remove OrgUnit")) {
			return Invoke-bConnectDelete -Controller "OrgUnits" -Data $_body
		}
	}
	else {
		return $false
	}
}