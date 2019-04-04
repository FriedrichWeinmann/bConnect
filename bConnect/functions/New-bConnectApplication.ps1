Function New-bConnectApplication
{
<#
	.Synopsis
		Create a new application.

	.DESCRIPTION
		Create a new application.

	.PARAMETER Name
		Name of the application to create.

	.PARAMETER Vendor
		Vendor of the application to create

	.PARAMETER ValidForOS
		The list of OS the application may be installed on.

	.PARAMETER Comment
		A comment to apply to the application.

	.PARAMETER ParentId
		The Guid of the container to create the application in..

	.PARAMETER Version
		The version of the application to create

	.PARAMETER Category
		The category the application is part of

	.PARAMETER InstallationData
		What is needed to install the application.
		Create with 'New-bConnectApplicationInstallationData'

	.PARAMETER UninstallationData
		What is needed to uninstall the application.

	.PARAMETER ConsistencyChecks
		The consistency checks used for the application

	.PARAMETER ApplicationFile
		The files that are part of the application.
		Create with 'New-bConnectApplicationFile'

	.PARAMETER Cost
		A description of the Cost parameter.

	.PARAMETER SecurityContext
		A description of the SecurityContext parameter.

	.PARAMETER Licenses
		A description of the Licenses parameter.

	.PARAMETER AUT
		A description of the AUT parameter.
#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)]
		[string]
		$Name,

		[Parameter(Mandatory = $true)]
		[string]
		$Vendor,

		[Parameter(Mandatory = $true)]
		[ValidateSet("NT4", "Windows2000", "WindowsXP", "WindowsServer2003", "WindowsVista", "WindowsServer2008", "Windows7", "WindowsServer2008R2", "WindowsXP_x64", "WindowsServer2003_x64", "WindowsVista_x64", "WindowsServer2008_x64", "Windows7_x64", "WindowsServer2008R2_x64", "Windows8", "WindowsServer2012", "Windows8_x64", "WindowsServer2012_x64", "Windows10", "Windows10_x64", "WindowsServer2016_x64")]
		[string[]]
		$ValidForOS,

		[string]
		$Comment,

		[string]
		$ParentId,

		[string]
		$Version,

		[string]
		$Category,

		[PSCustomObject]
		$InstallationData,

		[PSCustomObject]
		$UninstallationData,

		[string]
		$ConsistencyChecks,

		[PSCustomObject[]]
		$ApplicationFile,

		[float]
		$Cost = 0,

		[ValidateSet("AnyUser", "InstallUser", "LocalInstallUser", "LocalSystem", "LoggedOnUser", "RegisteredUser", "SpecifiedUser")]
		[string]
		$SecurityContext,

		[PSCustomObject[]]
		$Licenses,

		[PSCustomObject[]]
		$AUT
	)

	begin
	{
		Assert-bConnectConnection
	}
	process
	{
		$body = @{
			Name	   = $Name;
			Vendor	   = $Vendor;
			ValidForOS = $ValidForOS;
			Cost	   = $Cost
		}

		if ($Comment) { $body['Comment'] = $Comment }
		if ($ParentId) { $body['ParentId'] = $ParentId }
		if ($Version) { $body['Version'] = $Version }
		if ($Category) { $body['Category'] = $Category }
		if ($InstallationData) { $body['Installation'] = $InstallationData }
		if ($UninstallationData) { $body['Uninstallation'] = $UninstallationData }
		if ($ConsistencyChecks) { $body['ConsistencyChecks'] = $ConsistencyChecks }
		if ($SecurityContext) { $body['SecurityContext'] = $SecurityContext }
		if ($Licenses) { $body['Licenses'] = $Licenses }
		if ($AUT)
		{
			$body['AUT'] = $AUT
			$body['EnableAUT'] = $true
		}

		Invoke-bConnectPost -Controller "Applications" -Data $body
	}
}