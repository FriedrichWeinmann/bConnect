function ConvertTo-FlatObject
{
<#
	.SYNOPSIS
		Flatten an object to simplify discovery of data
	
	.DESCRIPTION
		Flatten an object. This function will take an object, and flatten the properties using their full path into a single object with one layer of properties.
		
		You can use this to flatten XML, JSON, and other arbitrary objects.
		
		This can simplify initial exploration and discovery of data returned by APIs, interfaces, and other technologies.
		
		NOTE:
		Use tools like Get-Member, Select-Object, and Show-Object to further explore objects.
		This function does not handle certain data types well.
		It was original designed to expand XML and JSON.
	
	.PARAMETER InputObject
		Object to flatten
	
	.PARAMETER Exclude
		Exclude any nodes in this list.
		Accepts wildcards.
		
		Example:
		-Exclude price, title
	
	.PARAMETER IncludeDefault
		Exclude default properties for sub objects.
		True by default.
		
		This simplifies views of many objects (e.g. XML) but may exclude data for others (e.g. if flattening a process, ProcessThread properties will be excluded)
	
	.PARAMETER Include
		Include only leaves in this list.  Accepts wildcards.
		
		Example:
		-Include Author, Title
	
	.PARAMETER Value
		Include only leaves with values like these arguments.  Accepts wildcards.
	
	.PARAMETER MaxDepth
		Stop recursion at this depth.
	
	.EXAMPLE
		#Pull unanswered PowerShell questions from StackExchange, Flatten the data to date a feel for the schema
		Invoke-RestMethod "https://api.stackexchange.com/2.0/questions/unanswered?order=desc&sort=activity&tagged=powershell&pagesize=10&site=stackoverflow" |
		ConvertTo-FlatObject -Include Title, Link, View_Count
		
		$object.items[0].owner.link : http://stackoverflow.com/users/1946412/julealgon
		$object.items[0].view_count : 7
		$object.items[0].link       : http://stackoverflow.com/questions/26910789/is-it-possible-to-reuse-a-param-block-across-multiple-functions
		$object.items[0].title      : Is it possible to reuse a &#39;param&#39; block across multiple functions?
		$object.items[1].owner.link : http://stackoverflow.com/users/4248278/nitin-tyagi
		$object.items[1].view_count : 8
		$object.items[1].link       : http://stackoverflow.com/questions/26909879/use-powershell-to-retreive-activated-features-for-sharepoint-2010
		$object.items[1].title      : Use powershell to retreive Activated features for sharepoint 2010
		...
	
	.EXAMPLE
		#Set up some XML to work with
		$object = [xml]'
		<catalog>
		    <book id="bk101">
		    <author>Gambardella, Matthew</author>
		    <title>XML Developers Guide</title>
		    <genre>Computer</genre>
		    <price>44.95</price>
		  </book>
		  <book id="bk102">
		    <author>Ralls, Kim</author>
		    <title>Midnight Rain</title>
		    <genre>Fantasy</genre>
		    <price>5.95</price>
		  </book>
		</catalog>'
		
		#Call the flatten command against this XML
		ConvertTo-FlatObject $object -Include Author, Title, Price
		
		#Result is a flattened object with the full path to the node, using $object as the root.
		#Only leaf properties we specified are included (author,title,price)
		
		$object.catalog.book[0].author : Gambardella, Matthew
		$object.catalog.book[0].title  : XML Developers Guide
		$object.catalog.book[0].price  : 44.95
		$object.catalog.book[1].author : Ralls, Kim
		$object.catalog.book[1].title  : Midnight Rain
		$object.catalog.book[1].price  : 5.95
		
		#Invoking the property names should return their data if the orginal object is in $object:
		$object.catalog.book[1].price
		5.95
		
		$object.catalog.book[0].title
		XML Developers Guide
	
	.EXAMPLE
		#Set up some XML to work with
		[xml]'<catalog>
		  <book id="bk101">
		    <author>Gambardella, Matthew</author>
		    <title>XML Developers Guide</title>
		    <genre>Computer</genre>
		    <price>44.95</price>
		  </book>
		  <book id="bk102">
		    <author>Ralls, Kim</author>
		    <title>Midnight Rain</title>
		    <genre>Fantasy</genre>
		    <price>5.95</price>
		  </book>
		</catalog>' |
		ConvertTo-FlatObject -exclude price, title, id
		
		Result is a flattened object with the full path to the node, using XML as the root.  Price and title are excluded.
		
		$Object.catalog                : catalog
		$Object.catalog.book           : {book, book}
		$object.catalog.book[0].author : Gambardella, Matthew
		$object.catalog.book[0].genre  : Computer
		$object.catalog.book[1].author : Ralls, Kim
		$object.catalog.book[1].genre  : Fantasy
	
	.EXAMPLE
		#Set up some XML to work with
		[xml]'<catalog>
		  <book id="bk101">
		    <author>Gambardella, Matthew</author>
		    <title>XML Developers Guide</title>
		    <genre>Computer</genre>
		    <price>44.95</price>
		  </book>
		  <book id="bk102">
		    <author>Ralls, Kim</author>
		    <title>Midnight Rain</title>
		    <genre>Fantasy</genre>
		    <price>5.95</price>
		  </book>
		</catalog>' |
		ConvertTo-FlatObject -Value XML*, Fantasy
		
		Result is a flattened object filtered by leaves that matched XML* or Fantasy
		
		$Object.catalog.book[0].title : XML Developers Guide
		$Object.catalog.book[1].genre : Fantasy
	
	.EXAMPLE
		#Get a single process with all props, flatten this object. Don't exclude default properties
		Get-Process | select -first 1 -skip 10 -Property * | ConvertTo-FlatObject -IncludeDefault
		
		#NOTE - There will likely be bugs for certain complex objects like this.
		For example, $Object.StartInfo.Verbs.SyncRoot.SyncRoot... will loop until we hit MaxDepth. (Note: SyncRoot is now addressed individually)
	
	.INPUTS
		Any object
	
	.OUTPUTS
		System.Management.Automation.PSCustomObject
	
	.NOTES
		I have trouble with algorithms.  If you have a better way to handle this, please let me know!
	
	.FUNCTIONALITY
		General Command
#>
	[cmdletbinding()]
	param (
		[parameter(Mandatory = $True, ValueFromPipeline = $True)]
		[PSObject[]]
		$InputObject,
		
		[string[]]
		$Exclude = "",
		
		[switch]
		$IncludeDefault,
		
		[string[]]
		$Include,
		
		[string[]]
		$Value,
		
		[int]
		$MaxDepth = 10
	)
	begin
	{
		#region FUNCTIONS
		
		# Before adding a property, verify that it matches a Like comparison to strings in $Include...
		function Test-Include
		{
			[CmdletBinding()]
			param (
				$PropertyName,
				
				[string[]]
				$Include
			)
			if (-not $Include) { return $true }
			else
			{
				foreach ($Inc in $Include)
				{
					if ($PropertyName -like $Inc)
					{
						return $true
					}
				}
			}
			return $false
		}
		
		# Before adding a value, verify that it matches a Like comparison to strings in $Value...
		function Test-Value
		{
			[CmdletBinding()]
			param (
				$ReferenceValue,
				
				[string[]]
				$Value
			)
			if (-not $Value) { return $True }
			foreach ($string in $Value)
			{
				if ($ReferenceValue -like $string)
				{
					return $true
				}
			}
			return $false
		}
		
		function Get-Exclude
		{
			[cmdletbinding()]
			param (
				$Object,
				
				[bool]
				$IncludeDefault,
				
				[string[]]
				$Exclude
			)
			
			# Exclude default props if specified, and anything the user specified.  Thanks to Jaykul for the hint on [type]!
			if (-not $IncludeDefault)
			{
				try
				{
					$defaultTypeProps = @($Object.gettype().GetProperties() | Select-Object -ExpandProperty Name -ErrorAction Stop)
					if ($defaultTypeProps.count -gt 0)
					{
						Write-PSFMessage -Level Verbose -Message "Excluding default properties for $($Object.gettype().Fullname):`n$($defaultTypeProps | Out-String)" -FunctionName 'ConvertTo-FlatObject'
					}
				}
				catch
				{
					Write-PSFMessage -Level Verbose -Message "Failed to extract properties from $($Object.gettype().Fullname): $_" -FunctionName 'ConvertTo-FlatObject'
					$defaultTypeProps = @()
				}
			}
			
			@($Exclude + $defaultTypeProps) | Select-Object -Unique
		}
		
		# Function to recurse the Object, add properties to object
		function Recurse-Object
		{
			[cmdletbinding()]
			param (
				$Object,
				
				[string[]]
				$Path = '$Object',
				
				$Output,
				
				[int]
				$Depth = 0,
				
				[int]
				$MaxDepth,
				
				[bool]
				$IncludeDefault,
				
				[string[]]
				$Exclude,
				
				[string[]]
				$Value,
				
				[string[]]
				$Include
			)
			
			# Handle initial call
			Write-PSFMessage -Level Verbose -Message "Working in path $Path at depth $Depth" -FunctionName 'ConvertTo-FlatObject'
			Write-PSFMessage -Level Debug -Message "Recurse Object called with PSBoundParameters:`n$($PSBoundParameters | Out-String)" -FunctionName 'ConvertTo-FlatObject'
			$Depth++
			
			# Exclude default props if specified, and anything the user specified.                
			$ExcludeProps = @(Get-Exclude -Object $object -IncludeDefault $IncludeDefault -Exclude $Exclude)
			
			# Get the children we care about, and their names
			$Children = $object.psobject.properties | Where-Object Name -notin $ExcludeProps
			Write-PSFMessage -Level Debug -Message "Working on properties:`n$($Children | Select-Object -ExpandProperty Name | Out-String)" -FunctionName 'ConvertTo-FlatObject'
			
			# Loop through the children properties.
			foreach ($Child in @($Children))
			{
				$ChildName = $Child.Name
				$ChildValue = $Child.Value
				
				Write-PSFMessage -Level Debug -Message "Working on property $ChildName with value $($ChildValue | Out-String)" -FunctionName 'ConvertTo-FlatObject'
				# Handle special characters...
				if ($ChildName -match '[^a-zA-Z0-9_]')
				{
					$FriendlyChildName = "{$ChildName}"
				}
				else
				{
					$FriendlyChildName = $ChildName
				}
				
				# Add the property.
				if ((Test-Include -PropertyName $ChildName -Include $Include) -and (Test-Value -ReferenceValue $ChildValue -Value $Value) -and $Depth -le $MaxDepth)
				{
					$ThisPath = @($Path + $FriendlyChildName) -join "."
					$Output | Add-Member -MemberType NoteProperty -Name $ThisPath -Value $ChildValue
					Write-PSFMessage -Level Verbose -Message "Adding member '$ThisPath'" -FunctionName 'ConvertTo-FlatObject'
				}
				
				# Handle null...
				if ($null -eq $ChildValue)
				{
					Write-PSFMessage -Level Verbose -Message "Skipping NULL $ChildName" -FunctionName 'ConvertTo-FlatObject'
					continue
				}
				
				# Handle evil looping.  Will likely need to expand this.  Any thoughts on a better approach?
				if (
					(
						$ChildValue.GetType() -eq $Object.GetType() -and
						$ChildValue -is [datetime]
					) -or
					(
						$ChildName -eq "SyncRoot" -and
						-not $ChildValue
					)
				)
				{
					Write-PSFMessage -Level Verbose -Message "Skipping $ChildName with type $($ChildValue.GetType().fullname)" -FunctionName 'ConvertTo-FlatObject'
					continue
				}
				
				# Check for arrays
				$IsArray = @($ChildValue).count -gt 1
				$count = 0
				
				# Set up the path to this node and the data...
				$CurrentPath = @($Path + $FriendlyChildName) -join "."
				
				# Exclude default props if specified, and anything the user specified.                
				$ExcludeProps = @(Get-Exclude -Object $ChildValue -IncludeDefault $IncludeDefault -Exclude $Exclude)
				
				# Get the children's children we care about, and their names.  Also look for signs of a hashtable like type
				$ChildrensChildren = $ChildValue.psobject.properties | Where-Object Name -notin $ExcludeProps
				$HashKeys = if ($ChildValue.Keys -notlike $null -and $ChildValue.Values)
				{
					$ChildValue.Keys
				}
				else
				{
					$null
				}
				Write-PSFMessage -Level Debug -Message "Found children's children $($ChildrensChildren | Select-Object -ExpandProperty Name | Out-String)" -FunctionName 'ConvertTo-FlatObject'
				
				# If we aren't at max depth or a leaf...                   
				if (
					(@($ChildrensChildren).count -ne 0 -or $HashKeys) -and
					$Depth -lt $MaxDepth
				)
				{
					# This handles hashtables.  But it won't recurse... 
					if ($HashKeys)
					{
						Write-PSFMessage -Level Verbose -Message "Working on hashtable $CurrentPath" -FunctionName 'ConvertTo-FlatObject'
						foreach ($key in $HashKeys)
						{
							Write-PSFMessage -Level Verbose -Message "Adding value from hashtable $CurrentPath['$key']" -FunctionName 'ConvertTo-FlatObject'
							$Output | Add-Member -MemberType NoteProperty -name "$CurrentPath['$key']" -value $ChildValue["$key"]
							$Output = Recurse-Object -Object $ChildValue["$key"] -Path "$CurrentPath['$key']" -Output $Output -Depth $Depth -MaxDepth $MaxDepth -IncludeDefault $IncludeDefault -Exclude $Exclude -Value $Value -Include $Include
						}
					}
					# Sub children?  Recurse!
					else
					{
						if ($IsArray)
						{
							foreach ($item in @($ChildValue))
							{
								Write-PSFMessage -Level Verbose -Message "Recursing through array node '$CurrentPath'" -FunctionName 'ConvertTo-FlatObject'
								$Output = Recurse-Object -Object $item -Path "$CurrentPath[$count]" -Output $Output -Depth $Depth -MaxDepth $MaxDepth -IncludeDefault $IncludeDefault -Exclude $Exclude -Value $Value -Include $Include
								$Count++
							}
						}
						else
						{
							Write-PSFMessage -Level Verbose -Message "Recursing through node '$CurrentPath'" -FunctionName 'ConvertTo-FlatObject'
							$Output = Recurse-Object -Object $ChildValue -Path $CurrentPath -Output $Output -Depth $Depth -MaxDepth $MaxDepth -IncludeDefault $IncludeDefault -Exclude $Exclude -Value $Value -Include $Include
						}
					}
				}
			}
			
			$Output
		}
		
		#endregion FUNCTIONS
	}
	process
	{
		foreach ($Object in $InputObject)
		{
			# Flatten the XML and write it to the pipeline
			Recurse-Object -Object $Object -Output $(New-Object -TypeName PSObject) -MaxDepth $MaxDepth -IncludeDefault $IncludeDefault.ToBool() -Exclude $Exclude -Value $Value -Include $Include
		}
	}
}