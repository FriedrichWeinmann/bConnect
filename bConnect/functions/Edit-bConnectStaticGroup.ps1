
function Edit-bConnectStaticGroup
{
<#
	.SYNOPSIS
		Updates a existing StaticGroup.
	
	.DESCRIPTION
		Updates a existing StaticGroup.
	
	.PARAMETER StaticGroup
		Valid modified StaticGroup
	
	.OUTPUTS
		StaticGroup
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Test-PSFShouldProcess is used instead of ShouldProcess.")]
	[CmdletBinding(ConfirmImpact = 'Medium', SupportsShouldProcess = $true)]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[PSCustomObject]
		$StaticGroup
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		If (Test-Guid $StaticGroup.Id)
		{
			# bms2016r1
			# We can not send the whole object because of not editable fields.
			# So we need to create a new one with editable fields only...
			# And as this might be too easy we face another problem: we are only allowed to send the changed fields :(
			# Dirty workaround: reload the object and compare new vs. old
			$oldGroup = Get-bConnectStaticGroup -StaticGroup $StaticGroup.Id
			$oldGroup = ConvertTo-Hashtable $oldGroup
			
			$newGroup = @{ Id = $StaticGroup.Id }
			$propertyList = @(
				"ParentId",
				"Name",
				"EndpointIds",
				"Comment"
			)
			$StaticGroup = ConvertTo-Hashtable $StaticGroup
			
			$endpointIds = @()
			Foreach ($endpointID in $StaticGroup.EndpointIds)
			{
				$endpointIds += $endpointID.Id
			}
			$StaticGroup.EndpointIds = $endpointIds
			
			Foreach ($property in $propertyList)
			{
				If ($StaticGroup[$property] -ine $oldGroup[$property])
				{
					$newGroup += @{ $property = $StaticGroup[$property] }
				}
			}
			
			if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $StaticGroup.Id -Action 'Edit Static Group')
			{
				Invoke-bConnectPatch -Controller "StaticGroups" -objectGuid $StaticGroup.Id -Data $newGroup | Add-ObjectDetail -TypeName 'bConnect.StaticGroup' -WithID
			}
			else
			{
				Write-PSFMessage -Level Verbose -Message "Edit Static Group"
				foreach ($k in $newGroup.Keys) { Write-PSFMessage -Level SomewhatVerbose -Message "$k : $($newGroup[$k])" }
			}
		}
		
	}
}
