Function Get-bConnectBootEnv() {
    <#
        .Synopsis
            Get specified BootEnvironment or a list of all boot environments
        .Parameter BootEnvironmentGuid
            Valid GUID of a boot environment
        .Outputs
            Array of BootEnvironment (see bConnect documentation for more details)
    #>
	
	Param (
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$BootEnvironmentGuid
	)
	begin {
		$Test = Test-bConnect
		
		if ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			throw $ErrorObject
		}
	}
	process {
		if ($BootEnvironmentGuid) {
			$_body = @{
				Id = $BootEnvironmentGuid
			}
		}
		
		$Result = Invoke-bConnectGet -Controller "BootEnvironment" -Data $_body | Select-Object  @{ Name = "BootEnvironmentGuid"; Expression = { $_.ID } }, *
		$Result | ForEach-Object {
			if ($_.PSObject.Properties.Name -contains 'ID') {
				Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.BootEnvironment'
			}
			else {
				$_
			}
		}
	}
}