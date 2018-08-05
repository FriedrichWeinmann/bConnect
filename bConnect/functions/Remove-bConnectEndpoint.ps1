<#
	.Synopsis
		Remove specified endpoint.
	
	.DESCRIPTION
		A detailed description of the Remove-bConnectEndpoint function.
	
	.Parameter EndpointGuid
		Valid GUID of a endpoint.
	
	.Parameter Endpoint
		Valid Endpoint object
	
	.Outputs
		Bool
	
	.NOTES
		Additional information about the function.
#>
function Remove-bConnectEndpoint {
	[CmdletBinding(ConfirmImpact = 'High',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$EndpointGuid,
		[PSCustomObject]$Endpoint
	)
	
	BEGIN {
		$Test = Test-bConnect
		
		If ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			Throw $ErrorObject
		}
	}
	PROCESS {
		If (![string]::IsNullOrEmpty($EndpointGuid)) {
			$_body = @{
				Id	   = $EndpointGuid
			}
		}
		elseif (![string]::IsNullOrEmpty($Endpoint.Id)) {
			$_body = @{
				Id	   = $Endpoint.Id
			}
		}
		else {
			return $false
		}
		if ($pscmdlet.ShouldProcess($EndpointGuid, "Remove Endpoints")) {
			$Result = Invoke-bConnectDelete -Controller "Endpoints" -Data $_body
		}
	}
	END {
		$Result
	}
}
