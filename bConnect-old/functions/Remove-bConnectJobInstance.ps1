Function Remove-bConnectJobInstance() {
    <#
        .Synopsis
            Remove specified jobinstance.
        .Parameter JobInstanceGuid
            Valid GUID of a jobinstance.
        .Outputs
            Bool
    #>
	[CmdletBinding(SupportsShouldProcess = $true)]
	Param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]	
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$JobInstanceGuid
	)
	
	$_connectVersion = Get-bConnectVersion
	If ($_connectVersion -ge "1.0") {
		$_body = @{
			Id    = $JobInstanceGuid
		}
		if ($pscmdlet.ShouldProcess($JobInstanceGuid, "Remove JobInstance")) {
			return Invoke-bConnectDelete -Controller "JobInstances" -Data $_body
		}

	}
	else {
		return $false
	}
}