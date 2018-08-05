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
			
			$_orgUnit = ConvertTo-Hashtable $OrgUnit
			if ($pscmdlet.ShouldProcess($_orgUnit.Id, "Edit OrgUnit"))
			{
				Invoke-bConnectPatch -Controller "OrgUnits" -objectGuid $OrgUnit.Id -Data $_orgUnit | Select-PSFObject  "ID as OrgUnitGuid", * | ForEach-Object {
					if ($_.PSObject.Properties.Name -contains 'OrgUnitGuid')
					{
						Add-ObjectDetail -InputObject $_ -TypeName 'bConnect.OrgUnit'
					}
					else
					{
						$_
					}
				}
			}
			else
			{
				Write-Verbose -Message "Edit OrgUnit"
				foreach ($k in $_orgUnit.Keys) { Write-Verbose -Message "$k : $($_orgUnit[$k])" }
			}
		}
	}
}