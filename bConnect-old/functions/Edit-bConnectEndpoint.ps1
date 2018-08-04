<#
	.Synopsis
		Updates a existing endpoint.
	
	.DESCRIPTION
		A detailed description of the Edit-bConnectEndpoint function.
	
	.Parameter Endpoint
		Valid modified endpoint
	
	.Outputs
		Endpoint (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
function Edit-bConnectEndpoint {
	[CmdletBinding(ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
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
		If (Test-Guid $Endpoint.EndpointGuid) {
			# bms2016r1
			# We can not send the whole object because of not editable fields.
			# So we need to create a new one with editable fields only...
			# And as this might be too easy we face another problem: we are only allowed to send the changed fields :(
			# Dirty workaround: reload the object and compare new vs. old
			$_old_endpoint = Get-bConnectEndpoint -EndpointGuid $Endpoint.Id
			$_old_endpoint = ConvertTo-Hashtable $_old_endpoint
			
			# common properties
			$_new_endpoint = @{ Id = $Endpoint.Id }
			$_propertyList = @(
				"DisplayName",
				"GuidOrgUnit"
			)
			$Endpoint = ConvertTo-Hashtable $Endpoint
			
			# Windows
			If ($Endpoint.Type -eq [bConnectEndpointType]::WindowsEndpoint) {
				$_propertyList += @(
					"HostName",
					"Options",
					"PrimaryMAC",
					"Domain",
					"GuidBootEnvironment",
					"GuidHardwareProfile",
					"PublicKey",
					"Comments"
				)
			}
			
			# BmsNet = Android, iOS, WP, OSX
			If (($Endpoint.Type -eq [bConnectEndpointType]::AndroidEndpoint) -or
				($Endpoint.Type -eq [bConnectEndpointType]::iOSEndpoint) -or
				($Endpoint.Type -eq [bConnectEndpointType]::WindowsPhoneEndpoint) -or
				($Endpoint.Type -eq [bConnectEndpointType]::MacEndpoint)) {
				$_propertyList += @(
					"PrimaryUser",
					"Owner",
					"ComplianceCheckCategory"
				)
			}
			
			# OSX
			If ($Endpoint.Type -eq [bConnectEndpointType]::MacEndpoint) {
				$_propertyList += @(
					"HostName"
				)
			}
			
			Foreach ($_property in $_propertyList) {
				If ($Endpoint[$_property] -ine $_old_endpoint[$_property]) {
					$_new_endpoint += @{ $_property = $Endpoint[$_property] }
				}
			}
			
			if ($pscmdlet.ShouldProcess($Endpoint.Id, "Edit Endpoint")) {
				$Result = Invoke-bConnectPatch -Controller "Endpoints" -objectGuid $Endpoint.Id -Data $_new_endpoint | Select-Object  @{ Name = "EndpointGuid"; Expression = { $_.ID } }, *
				$Result | ForEach-Object {
					if ($_.PSObject.Properties.Name -contains 'ID') {
						Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.Endpoint'
					}
					else {
						$_
					}
				}
			}
			else {
				Write-Verbose -Message "Edit Endpoint"
				foreach ($k in $_new_endpoint.Keys) { Write-Verbose -Message "$k : $($_new_endpoint[$k])" }
			}
		}
		
	}
}
