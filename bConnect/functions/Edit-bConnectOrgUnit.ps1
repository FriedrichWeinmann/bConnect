Function Edit-bConnectOrgUnit
{
<#
	.SYNOPSIS
		Updates a existing OrgUnit.
	
	.DESCRIPTION
		Updates a existing OrgUnit.
	
	.Parameter OrgUnit
		Valid modified OrgUnit
	
	.OUTPUTS
		OrgUnit
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Test-PSFShouldProcess is used instead of ShouldProcess.")]
	[CmdletBinding(ConfirmImpact = 'Medium', SupportsShouldProcess = $true)]
	Param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[PSCustomObject]
		$OrgUnit
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	
	process
	{
		If (Test-Guid $OrgUnit.Id)
		{
			$orgUnitItem = ConvertTo-Hashtable $OrgUnit
			
			if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $orgUnitItem.Id -Action 'Edit OrgUnit')
			{
				Invoke-bConnectPatch -Controller "OrgUnits" -objectGuid $OrgUnit.Id -Data $orgUnitItem |
				Select-PSFObject  "ID as OrgUnitGuid", * |
				Add-ObjectDetail -TypeName 'bConnect.OrgUnit' -WithID
			}
			else
			{
				Write-PSFMessage -Level Verbose -Message "Edit OrgUnit"
				foreach ($k in $orgUnitItem.Keys) { Write-PSFMessage -Level SomewhatVerbose -Message "$k : $($orgUnitItem[$k])" }
			}
		}
	}
}