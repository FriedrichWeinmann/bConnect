<#
	.Synopsis
		Get all links between endpoints and software scan rules.
	
	.DESCRIPTION
		A detailed description of the Get-bConnectEndpointInvSoftware function.
	
	.PARAMETER EndpointGuid
		Valid GUID of a endpoint
	
	.PARAMETER SoftwareScanRuleGuid
		Valid GUID of a Software Scan Rule
	
	.EXAMPLE
		PS C:\> Get-bConnectEndpointInvSoftware
	
	.Outputs
		EndpointInvSoftware (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
function Get-bConnectEndpointInvSoftware {
	param
	(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$EndpointGuid,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$SoftwareScanRuleGuid
	)
	
	BEGIN {
		$Test = Test-bConnect
		
		If ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			Throw $ErrorObject
		}
	}
	PROCESS {
		$WhereArray = @()
		if (-Not ([String]::IsNullOrEmpty($EndpointGuid))) {
			$WhereArray += '$_.GuidEndpoint -eq $EndpointGuid'
		}
		if (-Not ([String]::IsNullOrEmpty($SoftwareScanRuleGuid))) {
			$WhereArray += '$_.GuidRule -eq $SoftwareScanRuleGuid'
		}
		$WhereString = $WhereArray -Join " -and "
		
		Write-Progress -Activity "Fetching Inventory Data" -Status "Progress:" -PercentComplete "25"
		$Result = Invoke-bConnectGet -Controller "EndpointInvSoftware" -Data $_body
		Write-Progress -Activity "Validating Data" -Status "Progress:" -PercentComplete "50"
		$Result = $Result | ForEach-Object {
			if ($_.PSObject.Properties.Name -contains 'GuidEndpoint') {
				Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.EndpointInvSoftware'
			}
			else {
				$_
			}
		}
		
		if (-Not ([String]::IsNullOrEmpty($WhereString))) {
			Write-Progress -Activity "Filtering Data" -Status "Progress:" -PercentComplete "75"
			$WhereBlock = [scriptblock]::Create($WhereString)
			$Result = $Result | Where-Object -FilterScript $WhereBlock
		}
	}
	END {
		$Result
	}
	
}