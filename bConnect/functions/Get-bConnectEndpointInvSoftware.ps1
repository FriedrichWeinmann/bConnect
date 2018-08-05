function Get-bConnectEndpointInvSoftware
{
<#
	.SYNOPSIS
		Get all links between endpoints and software scan rules.
	
	.DESCRIPTION
		Get all links between endpoints and software scan rules.
	
	.PARAMETER EndpointGuid
		Valid GUID of a endpoint
	
	.PARAMETER SoftwareScanRuleGuid
		Valid GUID of a Software Scan Rule
	
	.Outputs
		bConnect.EndpointInvSoftware
#>
	param
	(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$EndpointGuid,
		
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[PsfValidatePattern('\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b', ErrorMessage = 'Failed to parse input as guid: {0}')]
		[string]
		$SoftwareScanRuleGuid
	)
	
	begin
	{
		Assert-bConnectConnection
		
		$filterCondition = {
			if (($EndpointGuid) -and ($_.GuidEndpoint -ne $EndpointGuid))
			{
				return $false
			}
			if (($SoftwareScanRuleGuid) -and ($_.GuidRule -eq $SoftwareScanRuleGuid))
			{
				return $false
			}
			return $true
		}
	}
	process
	{
		Invoke-bConnectGet -Controller "EndpointInvSoftware" -Data @{ } |
		Where-Object $filterCondition |
		Add-ObjectDetail -TypeName 'bConnect.EndpointInvSoftware' -WithID
	}
	
}