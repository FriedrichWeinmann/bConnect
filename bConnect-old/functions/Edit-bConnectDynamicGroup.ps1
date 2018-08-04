<#
	.Synopsis
		Updates a existing DynamicGroup.
	
	.DESCRIPTION
		A detailed description of the Edit-bConnectDynamicGroup function.
	
	.Parameter DynamicGroup
		Valid modified DynamicGroup
	
	.Outputs
		DynamicGroup (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
function Edit-bConnectDynamicGroup {
	[CmdletBinding(ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[PSCustomObject]$DynamicGroup
	)
	
	BEGIN {
		$Test = Test-bConnect
		
		If ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			Throw $ErrorObject
		}
	}
	PROCESS {
		If (Test-Guid $DynamicGroup.Id) {
			# bms2016r1
			# We can not send the whole object because of not editable fields.
			# So we need to create a new one with editable fields only...
			# And as this might be too easy we face another problem: we are only allowed to send the changed fields :(
			# Dirty workaround: reload the object and compare new vs. old
			$_old_group = Get-bConnectDynamicGroup -DynamicGroup $DynamicGroup.Id
			$_old_group = ConvertTo-Hashtable $_old_group
			
			$_new_group = @{ Id = $DynamicGroup.Id }
			$_propertyList = @(
				"ParentId",
				"Name",
				"Statement",
				"Comment"
			)
			$DynamicGroup = ConvertTo-Hashtable $DynamicGroup
			
			Foreach ($_property in $_propertyList) {
				If ($DynamicGroup[$_property] -ine $_old_group[$_property]) {
					$_new_group += @{ $_property = $DynamicGroup[$_property] }
				}
			}
			
			#Workaround for a bug in bConnect 2016r1
			# we need to assign the property "Name" even if it is unchanged.
			# otherwise the controller returns an error...
			If ($_new_group.Keys -notcontains "Name") {
				$_new_group += @{ "Name" = $DynamicGroup["Name"] }
			}
			
			if ($pscmdlet.ShouldProcess($DynamicGroup.Id, "Edit Dynamic Group")) {
				$Result = Invoke-bConnectPatch -Controller "DynamicGroups" -objectGuid $DynamicGroup.Id -Data $_new_group
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
				Write-Verbose -Message "Edit Dynamic Group"
				foreach ($k in $_new_group.Keys) { Write-Verbose -Message "$k : $($_new_group[$k])" }
			}
		}
		
	}
}