Function Get-bConnectSoftwareScanRuleCount
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
        try
        {
            Invoke-bConnectGet -Controller "SoftwareScanRuleCounts"
        }
        catch
        {
            $RulesToEndpoint = Get-bConnectEndpointInvSoftware
            $Endpoints = @{}
            Get-bConnectEndpoint | ForEach-Object {$Endpoints[$_.ID] = $_ | Select-PSFObject ID, EndpointGuid, DisplayName}
            $SoftwareRules = Get-bConnectSoftwareScanRule

            $Result = @()
            foreach ($Rule in $RulesToEndpoint)
            {
                [PSCustomObject]$_Endpoint = $Endpoints[$Rule.GuidEndpoint]

                $Result += [PSCustomObject]@{
                    EndpointInfo = $_Endpoint
                    GuidRule     = $Rule.GuidRule
                }
            }

            $GroupedResults = @{}
            $Result | Group-Object GuidRule | ForEach-Object {$GroupedResults[$_.Name] = $_.Group}

            foreach ($Rule in $SoftwareRules)
            {
                [PSCustomObject]@{
                    InstalledCount     = $GroupedResults[$Rule.ID].Count
                    InstalledEndpoints = $GroupedResults[$Rule.ID].EndpointInfo
                    SoftwareScanRule   = $Rule
                }
            }
        }


    }
}