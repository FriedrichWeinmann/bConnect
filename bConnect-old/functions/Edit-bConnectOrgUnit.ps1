Function Edit-bConnectOrgUnit() {
    <#
        .Synopsis
            Updates a existing OrgUnit.
        .Parameter OrgUnit
            Valid modified OrgUnit
        .Outputs
            OrgUnit (see bConnect documentation for more details).
    #>
	
	[CmdletBinding(ConfirmImpact = 'Medium',
		SupportsShouldProcess = $true)]
	Param (
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[PSCustomObject]$OrgUnit
	)
	
	BEGIN {
		$Test = Test-bConnect
		
		If ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			Throw $ErrorObject
		}
	}

	PROCESS {
		If (Test-Guid $OrgUnit.Id) {
			
			$_orgUnit = ConvertTo-Hashtable $OrgUnit
			if ($pscmdlet.ShouldProcess($_orgUnit.Id, "Edit OrgUnit")) {
				$Result = Invoke-bConnectPatch -Controller "OrgUnits"  -objectGuid $OrgUnit.Id -Data $_orgUnit | Select-Object  @{ Name = "OrgUnitGuid"; Expression = { $_.ID } }, *
				$Result | ForEach-Object {
					if ($_.PSObject.Properties.Name -contains 'OrgUnitGuid') {
						Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.OrgUnit'
					}
					else {
						$_
					}
				}
			}
			else {
				Write-Verbose -Message "Edit OrgUnit"
				foreach ($k in $_orgUnit.Keys) { Write-Verbose -Message "$k : $($_orgUnit[$k])" }
			}
		}
	}
}