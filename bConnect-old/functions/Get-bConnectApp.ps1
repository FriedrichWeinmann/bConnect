Function Get-bConnectApp() {
    <#
        .Synopsis
            Get specified app, all apps in given OrgUnit or all apps on an specific endpoint.
        .Parameter AppGuid
            Valid GUID of a app.
        .Parameter OrgUnitGuid
            Valid GUID of a Orgunit.
        .Parameter EndpointGuid
            Valid GUID of an endpoint.
        .Outputs
            Array of App (see bConnect documentation for more details).
    #>
	
	Param (
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$AppGuid,
		[string]$OrgUnitGuid,
		[string]$EndpointGuid
	)

	BEGIN {
		$Test = Test-bConnect
		
		If ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			Throw $ErrorObject
		}
	}
	PROCESS {
		If ($EndpointGuid) {
			$_body = @{
				EndpointId    = $EndpointGuid
			}
		}
		
		If ($OrgUnitGuid) {
			$_body = @{
				OrgUnit    = $OrgUnitGuid
			}
		}
		
		If ($AppGuid) {
			$_body = @{
				Id    = $AppGuid
			}
		}
		
		$Result = Invoke-bConnectGet -Controller "Apps" -Data $_body | Select-Object  @{ Name = "AppGuid"; Expression = { $_.ID } }, *
		$Result = $Result | ForEach-Object {
			if ($_.PSObject.Properties.Name -contains 'Id') {
				Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.App'
			}
			else {
				$_
			}
		}
	}
	END {
		$Result
	}
}