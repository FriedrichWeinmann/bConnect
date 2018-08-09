function Edit-bConnectApplication
{
<#
	.SYNOPSIS
		Edits an existing Application
	
	.DESCRIPTION
		With Edit-bConnectApplication you can change various properties of existing Applications.
		The Cmdlet accepts an Application Object (easy to get via Get-bConnectApplication) or an
		hashtable. For Identification the object must have an ApplicationGuid Key with a valid
		GUID from an Application Object.
	
	.PARAMETER Application
		Application object (hashtable).
	
	.EXAMPLE
		PS C:\> Edit-bConnectApplication -Application $Application
	
		Set the properties from the Application object to an existing baramundi Application
	
	.EXAMPLE
		$MyApplication = Get-bConnectApplication -ApplicationGuid <GUID>
		$MyApplication.Version = "2.0"
		$MyApplication | Edit-bConnectApplication
	
		Get an existing baramundi Application, edit the Application Object and send the changed
		object with Edit-bConnectEndpoint back to the REST API
	
	.Outputs
		NewEndpoint (see bConnect documentation for more details).
	
	.NOTES
		Additional information about the function.
#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification="Test-PSFShouldProcess is used instead of ShouldProcess.")]
	[CmdletBinding(ConfirmImpact = 'Medium', SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		$Application
	)
	
	begin
	{
		Assert-bConnectConnection
	}
	
	process
	{
		If (Test-Guid $Application.ApplicationGuid)
		{
			If ($Application.AUT.Count -gt 0)
			{
				$Application.EnableAUT = $true
			}

			$newApplication = @{ Id = $Application.ApplicationGuid }

			$flatOldApplication = Get-bConnectApplication -ApplicationGuid $Application.ApplicationGuid | ConvertTo-FlatObject
			$flatNewApplication = $Application | ConvertTo-FlatObject

			$Diff = Compare-ObjectProperty -ReferenceObject $flatOldApplication -DifferenceObject $flatNewApplication

			If ($Diff.PropertyName.Count -gt 0) {
				foreach ($_Property in $Diff) {
					If( $_Property.PropertyName -match "\.([^\.]+)\.") {
						$newApplication += @{$Matches[1] = $Application.($Matches[1])}
					}
					
				}
				if (Test-PSFShouldProcess -PSCmdlet $PSCmdlet -Target $newApplication.ID -Action 'Edit Application')
				{
					Invoke-bConnectPatch -Controller "Applications" -objectGuid $newApplication.ID -Data $newApplication |
					Select-PSFObject 'ID as ApplicationGuid', * |
					Add-ObjectDetail -TypeName 'bConnect.Application' -WithID
				}
				else
				{
					Write-PSFMessage -Level Verbose -Message "Edit Application"
					foreach ($k in $newApplication.Keys) { Write-PSFMessage -Level Host -Message "$k : $($newApplication[$k])" }
				}
			}
		}
	}
}