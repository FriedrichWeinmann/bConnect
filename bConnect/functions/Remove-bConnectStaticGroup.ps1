Function Remove-bConnectStaticGroup() {
    <#
        .Synopsis
            Remove specified StaticGroup.
        .Parameter StaticGroupGuid
            Valid GUID of a StaticGroup.
        .Outputs
            Bool
    #>
	[CmdletBinding(SupportsShouldProcess = $true)]
	Param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]	
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$StaticGroupGuid
	)
	
	$_connectVersion = Get-bConnectVersion
	If ($_connectVersion -ge "1.0") {
		$_body = @{
			Id    = $StaticGroupGuid
		}
		
		if ($pscmdlet.ShouldProcess($StaticGroupGuid, "Remove StaticGroup")) {
			return Invoke-bConnectDelete -Controller "StaticGroups" -Data $_body
		}
	}
	else {
		return $false
	}
}