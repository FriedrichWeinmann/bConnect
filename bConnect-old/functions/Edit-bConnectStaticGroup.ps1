<#
	.Synopsis
		Updates a existing StaticGroup.
	
	.DESCRIPTION
		A detailed description of the Edit-bConnectStaticGroup function.
	
	.Parameter StaticGroup
		Valid modified StaticGroup
	
	.Outputs
		StaticGroup (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
function Edit-bConnectStaticGroup {
	[CmdletBinding(ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[PSCustomObject]$StaticGroup
	)
	
	BEGIN {
		$Test = Test-bConnect
		
		If ($Test -ne $true) {
			$ErrorObject = New-Object System.Net.WebSockets.WebSocketException "$Test"
			Throw $ErrorObject
		}
	}
	PROCESS {
		If (Test-Guid $StaticGroup.Id) {
			# bms2016r1
			# We can not send the whole object because of not editable fields.
			# So we need to create a new one with editable fields only...
			# And as this might be too easy we face another problem: we are only allowed to send the changed fields :(
			# Dirty workaround: reload the object and compare new vs. old
			$_old_group = Get-bConnectStaticGroup -StaticGroup $StaticGroup.Id
			$_old_group = ConvertTo-Hashtable $_old_group
			
			$_new_group = @{ Id = $StaticGroup.Id }
			$_propertyList = @(
				"ParentId",
				"Name",
				"EndpointIds",
				"Comment"
			)
			$StaticGroup = ConvertTo-Hashtable $StaticGroup
			
			$_endpointIds = @()
			Foreach ($_ep in $StaticGroup.EndpointIds) {
				$_endpointIds += $_ep.Id
			}
			$StaticGroup.EndpointIds = $_endpointIds
			
			Foreach ($_property in $_propertyList) {
				If ($StaticGroup[$_property] -ine $_old_group[$_property]) {
					$_new_group += @{ $_property = $StaticGroup[$_property] }
				}
			}
			
			if ($pscmdlet.ShouldProcess($StaticGroup.Id, "Edit Static Group")) {
				$Result = Invoke-bConnectPatch -Controller "StaticGroups" -objectGuid $StaticGroup.Id -Data $_new_group
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
				Write-Verbose -Message "Edit Static Group"
				foreach ($k in $_new_group.Keys) { Write-Verbose -Message "$k : $($_new_group[$k])" }
			}
		}
		
	}
}
