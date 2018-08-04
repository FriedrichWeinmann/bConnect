<#
	.Synopsis
		Get specified Static Group.
	
	.DESCRIPTION
		A detailed description of the Get-bConnectStaticGroup function.
	
	.Parameter StaticGroup
		Name (wildcards supported) or GUID of the Static Group.
	
	.Parameter OrgUnitGuid
		Valid GUID of a OrgUnit with Static Groups
	
	.Outputs
		Array of StaticGroup (see bConnect documentation for more details)
	
	.NOTES
		Additional information about the function.
#>
function Get-bConnectStaticGroup {
	param
	(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[Alias('StaticGroupGuid')]
		[string]$StaticGroup,
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b')]
		[string]$OrgUnitGuid
	)
	
	begin {
		$Test = Test-bConnect
		
		if ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			throw $ErrorObject
		}
	}
	process {
		If (![string]::IsNullOrEmpty($StaticGroup)) {
			If (Test-Guid $StaticGroup) {
				$_body = @{
					Id = $StaticGroup
				}
				
				$Result = Invoke-bConnectGet -Controller "StaticGroups" -Data $_body | Select-Object  @{ Name = "StaticGroupGuid"; Expression = { $_.ID } }, *
				$Result | ForEach-Object {
					if ($_.PSObject.Properties.Name -contains 'ID') {
						Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.StaticGroup'
					}
					else {
						$_
					}
				}
			}
			else {
				# fetching static groups with name is not supported; therefore we need a workaround for getting the specified static group...
				$_bmsVersion = Get-bConnectVersion -bMSVersion
				If ($_bmsVersion.Major -ge "16") {
					# Search available since bMS 2016R1
					$_groups = Search-bConnectStaticGroup -Term $StaticGroup
					$_ret_groups = @()
					Foreach ($_grp in $_groups) {
						$_ret_groups += Get-bConnectStaticGroup -StaticGroup $_grp.StaticGroupGuid
					}
					$_ret_groups
				}
			}
		}
		elseif (![string]::IsNullOrEmpty($OrgUnitGuid)) {
			If (Test-Guid $OrgUnitGuid) {
				$_body = @{
					OrgUnitGuid = $OrgUnitGuid
				}
				
				$Result = Invoke-bConnectGet -Controller "StaticGroups" -Data $_body | Select-Object  @{ Name = "StaticGroupGuid"; Expression = { $_.ID } }, *
				$Result | ForEach-Object {
					if ($_.PSObject.Properties.Name -contains 'ID') {
						Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.StaticGroup'
					}
					else {
						$_
					}
				}
			}
			else {
				return $false
			}
		}
		else {
			$Result = Invoke-bConnectGet -Controller "StaticGroups" | Select-Object  @{ Name = "StaticGroupGuid"; Expression = { $_.ID } }, *
			$Result | ForEach-Object {
				if ($_.PSObject.Properties.Name -contains 'ID') {
					Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.StaticGroup'
				}
				else {
					$_
				}
			}
		}
	}
}