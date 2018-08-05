Function New-bConnectApplicationFile
{
<#
	.Synopsis
		Creates a new ApplicationFile for Applications.
	
	.DESCRIPTION
		Creates a new ApplicationFile for Applications.
	
	.Parameter Source
		Path or file
	
	.Parameter Type
		Type of the source
#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)]
		[string]
		$Source,
		
		[Parameter(Mandatory = $true)]
		[ValidateSet("FolderWithSubFolders", "SingleFolder", "File")]
		[string]
		$Type
	)
	
	@{
		Source = $Source
		Type   = $Type
	}
}