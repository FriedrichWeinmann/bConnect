<#
	.Synopsis
		Get the Endpoints Options of an Endpoint
	
	.DESCRIPTION
		A detailed description of the Get-bConnectEndpointOption function.
	
	.PARAMETER EndpointGuid
		A description of the EndpointGuid parameter.
	
	.Outputs
		EndpointOptions Object.
	
	.NOTES
		Additional information about the function.
#>
function Get-bConnectEndpointOption {
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[Alias('EndpointIds')]
		[string[]]$EndpointGuid
	)
	
	begin {
		$Test = Test-bConnect
		
		if ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			throw $ErrorObject
		}
	}
	process {
		
		foreach ($_Endpoint in $EndpointGuid) {
			$Endpoint = Get-bConnectEndpoint -EndpointGuid $_Endpoint
			if ($Endpoint.Type -ne 1) {
				Write-Warning "Client ist kein Windows Endpunkt"
				return $false
			}
			if ($Endpoint.Options -lt [int32]::MaxValue) {
				
				[EndpointOptions]$Options = $Endpoint.Options
				
				$EndpointOptions = [PSCustomObject]@{
					'EndpointGuid' = $Endpoint.EndpointGuid;
					'GuidOrgUnit'  = $Endpoint.GuidGroup;
					'DisplayName'  = $Endpoint.DisplayName;
					'AllowOSInstall' = $Options.HasFlag([EndpointOptions]::AllowOSInstall);
					'AllowAutoInstall' = $Options.HasFlag([EndpointOptions]::AllowAutoInstall);
					'PrimaryUserUpdateOption' = [bConnectEndpointPrimaryUserUpdateOption].GetEnumValues() | Where-Object { $($options.ToString() -Split ", ") -contains $_ };
					'UserJobOptions' = [bConnectEndpointUserJobOptions].GetEnumValues() | Where-Object { $($options.ToString() -Split ", ") -contains $_ };;
					'AutomaticUsageTracking' = $Options.HasFlag([EndpointOptions]::AutomaticUsageTracking);
					'EnergyManagement' = $Options.HasFlag([EndpointOptions]::EnergyManagement);
				}
				$EndpointOptions
			}
			else {
				Write-Warning "Client ist deaktivert"
				return $false
			}
		}
		
	}
}