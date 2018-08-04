Function Remove-bConnectDynamicGroup() {
    <#
        .Synopsis
            Remove specified DynamicGroup.
        .Parameter DynamicGroupGuid
            Valid GUID of a DynamicGroup.
        .Outputs
            Bool
    #>
	[CmdletBinding(SupportsShouldProcess = $true)]
	Param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]	
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$DynamicGroupGuid
	)
	
	$_connectVersion = Get-bConnectVersion
	If ($_connectVersion -ge "1.0") {
		$_body = @{
			Id    = $DynamicGroupGuid
		}
		if ($pscmdlet.ShouldProcess($DynamicGroupGuid, "Remove DynamicGroup")) {
			return Invoke-bConnectDelete -Controller "DynamicGroups" -Data $_body
		}
	}
	else {
		return $false
	}
}