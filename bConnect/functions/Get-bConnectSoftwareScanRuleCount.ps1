Function Get-bConnectSoftwareScanRule
{
    <#
	.SYNOPSIS
		Get SoftwareScanRuleCount objects that provide the endpoints which match the software scan rule along with a count.

	.DESCRIPTION
		Get SoftwareScanRuleCount objects that provide the endpoints which match the software scan rule along with a count.
#>
    [CmdletBinding()]
    param ()

    begin
    {
        Assert-bConnectConnection
    }
    process
    {
        Invoke-bConnectGet -Controller "SoftwareScanRuleCounts"
    }
}