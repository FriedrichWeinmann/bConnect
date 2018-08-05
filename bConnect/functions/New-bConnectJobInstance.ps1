Function New-bConnectJobInstance() {
    <#
        .Synopsis
            Assign the specified job to a endpoint.
        .Parameter EndpointGuid
            Valid GUID of a endpoint.
        .Parameter JobGuid
            Valid GUID of a job.
        .Parameter StartIfExists
            Restart the existing jobinstance if there is one.
        .Outputs
            JobInstance (see bConnect documentation for more details).
    #>
	
	Param (
		[Parameter(Mandatory = $true)]
		[string]$EndpointGuid,
		[Parameter(Mandatory = $true)]
		[string]$JobGuid,
		[switch]$StartIfExists
	)
	
	$_connectVersion = Get-bConnectVersion
	If ($_connectVersion -ge "1.0") {
		$_body = @{
			EndpointId	     = $EndpointGuid;
			JobId		     = $JobGuid;
			StartIfExists    = $StartIfExists.ToString()
		}
		
		return Invoke-bConnectGet -Controller "JobInstances" -Data $_body
	}
	else {
		return $false
	}
}