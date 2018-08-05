Function Test-Guid
{
<#
    .SYNOPSIS
        Test for valid GUID.
	
	.DESCRIPTION
		Test whether the input string contains a valid Guid as an isolated "word"

    .PARAMETER Guid
        String to test.
	
    .Outputs
        Bool
#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)]
		[string]$Guid
	)
	
	if ($Guid -match "\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b")
	{
		return $true
	}
	else
	{
		return $false
	}
}