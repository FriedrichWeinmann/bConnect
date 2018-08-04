<#
	.Synopsis
		Get specified Dynamic Group.
	
	.DESCRIPTION
		A detailed description of the Get-bConnectDynamicGroup function.
	
	.Parameter DynamicGroup
		Name (wildcards supported) or GUID of the Dynamic Group.
	
	.Parameter OrgUnit
		Valid GUID of a OrgUnit with Dynamic Groups
	
	.Outputs
		Array of DynamicGroup (see bConnect documentation for more details)
	
	.NOTES
		Additional information about the function.
#>
function Get-bConnectDynamicGroup {
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipelineByPropertyName = $true,
				   Position = 1)]
		[SupportsWildcards()]
		[string]$DynamicGroup,
		[Parameter(Position = 2)]
		[string]$OrgUnit
	)
	
	begin {
		$Test = Test-bConnect
		
		if ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			throw $ErrorObject
		}
	}
	process {
		If (![string]::IsNullOrEmpty($DynamicGroup)) {
			If (Test-Guid $DynamicGroup) {
				$_body = @{
					Id = $DynamicGroup
				}
				
				$Result = Invoke-bConnectGet -Controller "DynamicGroups" -Data $_body | Select-Object  @{ Name = "DynamicGroupGuid"; Expression = { $_.ID } }, *
				$Result | ForEach-Object {
					if ($_.PSObject.Properties.Name -contains 'ID') {
						Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.DynamicGroup'
					}
					else {
						$_
					}
				}
			}
			else {
				# fetching dynamic groups with name is not supported; therefore we need a workaround for getting the specified dyn group...
				$_bmsVersion = Get-bConnectVersion -bMSVersion
				If ($_bmsVersion.Major -ge "16") {
					# Search available since bMS 2016R1
					$_groups = Search-bConnectDynamicGroup -Term $DynamicGroup
					$_ret_groups = @()
					Foreach ($_grp in $_groups) {
						$_ret_groups += Get-bConnectDynamicGroup -DynamicGroup $_grp.DynamicGroupGuid
					}
					$_ret_groups
				}
			}
		}
		elseif (![string]::IsNullOrEmpty($OrgUnit)) {
			If (Test-Guid $OrgUnit) {
				$_body = @{
					OrgUnit = $OrgUnit
				}
				
				$Result = Invoke-bConnectGet -Controller "DynamicGroups" -Data $_body | Select-Object  @{ Name = "DynamicGroupGuid"; Expression = { $_.ID } }, *
				$Result | ForEach-Object {
					if ($_.PSObject.Properties.Name -contains 'ID') {
						Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.DynamicGroup'
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
			return Invoke-bConnectGet -Controller "DynamicGroups"
		}
	}
}