Function New-bConnectApplicationInstallationData
{
<#
	.SYNOPSIS
		Creates a new InstallationData for Applications.
		Empty or filled with given information.
	
	.DESCRIPTION
		Creates a new InstallationData for Applications.
		Empty or filled with given information.
	
	.PARAMETER Command
		Installation command
	
	.PARAMETER Parameter
		Parameter for installation command
	
	.PARAMETER ResponseFile
		ResponseFile for the installation
	
	.PARAMETER EngineFile
		File for installation engine (Engine will be set automatically based on EngineFile; only bDS supported in this PS module)
	
	.PARAMETER Options
		InstallApplicationOption object
	
	.PARAMETER UserSettings
		InstallUserSettings object
#>
	[CmdletBinding()]
	Param (
		[string]
		$Command,
		
		[string]
		$Parameter,
		
		[string]
		$ResponseFile,
		
		[string]
		$EngineFile,
		
		[PSCustomObject]
		$Options,
		
		[PSCustomObject]
		$UserSettings
	)
	
	$installationData = @{ }
	if ($Command) { $installationData['Command'] = $Command }
	if ($Parameter) { $installationData['Parameter'] = $Parameter }
	if ($ResponseFile) { $installationData['ResponseFile'] = $ResponseFile }
	if ($EngineFile)
	{
		$installationData['Engine'] = "baramundi Deploy Script"
		$installationData['EngineFile'] = $EngineFile
	}
	if ($Options) { $installationData['Options'] = $Options }
	if ($UserSettings) { $installationData['UserSettings'] = $UserSettings }
	
	return $installationData
}