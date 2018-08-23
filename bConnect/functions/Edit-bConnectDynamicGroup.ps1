function Edit-bConnectDynamicGroup
{
<#
	.SYNOPSIS
		Updates a existing DynamicGroup.
	
	.DESCRIPTION
		With Edit-bConnectDynamicGroup you can change the following properties:
			- Name (has to be unique in  the parent org unit)
			- Statement (a valid SQL Query)
			- ParentID (id of an org unit)
			- Comment
	
		The Cmdlet accepts an DynamicGroup Object (easy to get via Get-bConnectDynamicGroup) or an
		hashtable. For Identification the object must have an DynamicGroupGuid Key with a valid
		GUID from an DynamicGroup Object.
	
	.PARAMETER DynamicGroup
		Valid modified DynamicGroup
	
	.EXAMPLE
		PS C:\> Edit-bConnectDynamicGroup -DynamicGroup $DynamicGroup
	
		Set the properties from the DynamicGroup object to an existing baramundi Dynamic Group
	
	.EXAMPLE
		$MyGroup = Get-bConnectDynamicGroup -DynamicGroup <GUID> or <Name>
		$MyGroup.Name = "NewName"
		$MyGroup | Edit-bConnectDynamicGroup
	
		Get an existing baramundi Application, edit the Application Object and send the changed
		object with Edit-bConnectEndpoint back to the REST API
	
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