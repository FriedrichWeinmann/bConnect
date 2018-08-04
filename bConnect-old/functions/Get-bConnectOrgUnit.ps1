Function Get-bConnectOrgUnit() {
    <#
        .Synopsis
            Get specified OrgUnit.
        .Parameter OrgUnit
            Name (wildcards supported) or GUID of the OrgUnit.
        .Parameter SubGroups
            List subgroups of given OrgUnit.
            Only used if parameter "name" is a valid GUID.
        .Outputs
            Array of OrgUnit (see bConnect documentation for more details)
    #>
	
	Param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]	
		[string]$OrgUnit,
		[switch]$SubGroups
	)
	
	begin {
		$Test = Test-bConnect
		
		if ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			throw $ErrorObject
		}
	}
	process {
		If (Test-Guid $OrgUnit) {
			If ($SubGroups) {
				$_body = @{
					OrgUnit = $OrgUnit
				}
			}
			else {
				$_body = @{
					Id = $OrgUnit
				}
			}
			
			$Result = Invoke-bConnectGet -Controller "OrgUnits" -Data $_body | Select-Object  @{ Name = "OrgUnitGuid"; Expression = { $_.ID } }, *
			$Result | ForEach-Object {
				if ($_.PSObject.Properties.Name -contains 'ID') {
					Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.Group'
				}
				else {
					$_
				}
			}
		}
		else {
			# fetching orgunits with name is not supported; therefore we need a workaround for getting the specified orgunit...
			$_bmsVersion = Get-bConnectInfo
			If ($_bmsVersion.bMSVersion -imatch "16.*") {
				# Search available since bMS 2016R1
				$_groups = Search-bConnectOrgUnit -Term $OrgUnit
				
				$Result = $_groups | Select-Object  @{ Name = "OrgUnitGuid"; Expression = { $_.ID } }, *
				$Result | ForEach-Object {
					if ($_.PSObject.Properties.Name -contains 'ID') {
						Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.OrgUnit'
					}
					else {
						$_
					}
				}
			}
			else {
				# no search, so keep looping ;)
				$_groups = Invoke-bConnectGet -Controller "OrgUnits"
				$_ret = @()
				Foreach ($_group in $_groups) {
					If ($_group.Name -match $orgUnit) {
						$_ret += $_group
					}
				}
				$Result = $_ret | Select-Object  @{ Name = "OrgUnitGuid"; Expression = { $_.ID } }, *
				$Result | ForEach-Object {
					if ($_.PSObject.Properties.Name -contains 'ID') {
						Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.OrgUnit'
					}
					else {
						$_
					}
				}
			}
		}
	}
	
}