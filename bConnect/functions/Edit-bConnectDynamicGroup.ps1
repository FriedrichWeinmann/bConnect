function Edit-bConnectDynamicGroup
{
<#
	.SYNOPSIS
		Updates a existing DynamicGroup.
	
	.DESCRIPTION
		A detailed description of the Edit-bConnectDynamicGroup function.
	
	.PARAMETER DynamicGroup
		Valid modified DynamicGroup
	
	.OUTPUTS
		DynamicGroup (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Test-PSFShouldProcess is used instead of ShouldProcess.")]
	[CmdletBinding(ConfirmImpact = 'Medium', SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		$DynamicGroup
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		If (Test-Guid $DynamicGroup.Id)
		{
			# bms2016r1
			# We can not send the whole object because of not editable fields.
			# So we need to create a new one with editable fields only...
			# And as this might be too easy we face another problem: we are only allowed to send the changed fields :(
			# Dirty workaround: reload the object and compare new vs. old
			$oldGroup = Get-bConnectDynamicGroup -DynamicGroup $DynamicGroup.Id
			$oldGroup = ConvertTo-Hashtable $oldGroup
			
			$newGroup = @{ Id = $DynamicGroup.Id }
			$propertyList = @(
				"ParentId",
				"Name",
				"Statement",
				"Comment"
			)
			$DynamicGroup = ConvertTo-Hashtable $DynamicGroup
			
			Foreach ($property in $propertyList)
			{
				If ($DynamicGroup[$property] -ine $oldGroup[$property])
				{
					$newGroup += @{ $property = $DynamicGroup[$property] }
				}
			}
			
			#Workaround for a bug in bConnect 2016r1
			# we need to assign the property "Name" even if it is unchanged.
			# otherwise the controller returns an error...
			If ($newGroup.Keys -notcontains "Name")
			{
				$newGroup += @{ "Name" = $DynamicGroup["Name"] }
			}
			
			if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $DynamicGroup.Id -Action 'Edit Dynamic Group')
			{
				Invoke-bConnectPatch -Controller "DynamicGroups" -objectGuid $DynamicGroup.Id -Data $newGroup | Add-ObjectDetail -TypeName 'bConnect.DynamicGroup' -WithID
			}
			else
			{
				Write-PSFMessage -Level Verbose -Message "Edit Dynamic Group"
				foreach ($k in $newGroup.Keys) { Write-PSFMessage -Level SomewhatVerbose -Message "$k : $($newGroup[$k])" }
			}
		}
		
	}
}