<#
	.Synopsis
		Get specified jobinstance by GUID, all jobinstances of a job or all jobinstances on a endpoint.
	
	.DESCRIPTION
		A detailed description of the Get-bConnectJobInstance function.
	
	.Parameter JobInstanceGuid
		Valid GUID of a jobinstance.
	
	.Parameter JobGuid
		Valid GUID of a job.
	
	.Parameter EndpointGuid
		Valid GUID of a endpoint
	
	.Outputs
		Array of JobInstance (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
function Get-bConnectJobInstance {
	param
	(
		[Parameter(ValueFromPipelineByPropertyName = $true)]	
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$JobInstanceGuid,
		[Parameter(ValueFromPipelineByPropertyName = $true)]	
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$JobGuid,
		[Parameter(ValueFromPipelineByPropertyName = $true)]	
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$EndpointGuid
	)
	
	$_connectVersion = Get-bConnectVersion
	If ($_connectVersion -ge "1.0") {
		If ($JobGuid) {
			$_body = @{
				JobId	  = $JobGuid
			}
		}
		
		If ($EndpointGuid) {
			$_body = @{
				EndpointId	   = $EndpointGuid
			}
		}
		
		If ($JobInstanceGuid) {
			$_body = @{
				Id	   = $JobInstanceGuid
			}
		}
		
		return Invoke-bConnectGet -Controller "JobInstances" -Data $_body
	}
	else {
		return $false
	}
}