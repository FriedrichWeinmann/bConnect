Function Get-bConnectApplication() {
    <#
        .Synopsis
            Get specified application, all applications in given OrgUnit or all applications on an specific endpoint.
        .Parameter ApplicationGuid
            Valid GUID of a application.
        .Parameter OrgUnitGuid
            Valid GUID of a Orgunit.
        .Parameter EndpointGuid
            Valid GUID of an endpoint.
        .Outputs
            Array of Application (see bConnect documentation for more details).
    #>
	
	Param (
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$ApplicationGuid,
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
				EndpointId	   = $EndpointGuid
			}
		}
		
		If ($OrgUnitGuid) {
			$_body = @{
				OrgUnit	    = $OrgUnitGuid
			}
		}
		
		If ($ApplicationGuid) {
			$_body = @{
				Id	   = $ApplicationGuid
			}
		}
		
		$Result = Invoke-bConnectGet -Controller "Applications" -Data $_body | Select-Object  @{ Name = "ApplicationGuid"; Expression = { $_.ID } }, *
		$Result = $Result | ForEach-Object {
			if ($_.PSObject.Properties.Name -contains 'Id') {
				Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.Application'
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