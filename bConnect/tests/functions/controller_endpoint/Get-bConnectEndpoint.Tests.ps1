
InModuleScope bConnect {

    #region Prepare Test Environment
    $script:_connectInitialized = $true
    $script:_connectUri = "https://testserver"
    #endregion

    Describe 'Get-bConnectEndpoint Unit Test' -Tag "Unit" {

        beforeEach {
            $testEndpoints = Get-Content -Path "$PSScriptRoot\..\..\testdata\test_endpoints.json" | ConvertFrom-Json

            Mock -Verifiable Assert-bConnectConnection { }

            Mock -Verifiable -ModuleName bConnect Invoke-RestMethod {

                If ($Body)
                {
                    if ($Body.Id)
                    {
                        $endpoints = $testEndpoints | Where-Object {$_.Id -eq $Body.Id}
                    }
                    if ($Body.OrgUnit)
                    {
                        $endpoints = $testEndpoints | Where-Object {$_.GuidOrgUnit -eq $Body.OrgUnit}
                    }
                    if ($Body.DynamicGroup)
                    {
                        # While the Endpoint Object itself dosn't have any knowledge about its Group Membership
                        # we're using the GuidOrgUnit as a filter. Although if the DynamicGroupGuid is a valid
                        # Guid and a Parameter the REST API should send us the correct entpoints
                        $endpoints = $testEndpoints | Where-Object {$_.GuidOrgUnit -eq $Body.DynamicGroup}
                    }
                    if ($Body.StaticGroup)
                    {
                        # While the Endpoint Object itself dosn't have any knowledge about its Group Membership
                        # we're using the GuidOrgUnit as a filter. Although if the StaticGroupGuid is a valid
                        # Guid and a Parameter the REST API should send us the correct entpoints
                        $endpoints = $testEndpoints | Where-Object {$_.GuidOrgUnit -eq $Body.StaticGroup}
                    }
                    if ($Body.InstalledSoftware -eq $true)
                    {
                        $testSoftware = @()
                        $testSoftware += [PSCustomObject]@{
                            Id           = '0CFA6CEC-8BBC-4931-BFA8-F5E4A514F799'
                            Name         = 'TestsoftwareA'
                            Version      = '1.1.4'
                            Package      = ''
                            Manufacturer = 'Baramundi'
                        }
                        $testSoftware += [PSCustomObject]@{
                            Id           = '0CFA6CEC-8BBC-4931-BFA8-F5E4A514F799'
                            Name         = 'TestsoftwareB'
                            Version      = '2.1.4'
                            Package      = ''
                            Manufacturer = 'Baramundi'
                        }
                        $endpoints = $endpoints| ForEach-Object {
                            $_.InstalledSoftware = $testSoftware
                            Return $_
                        }
                    }
                    if ($Body.PubKey -eq $true)
                    {
                        $endpoints = $endpoints| ForEach-Object {
                            $_.PublicKey = "40822422300d06092a864886f70d01010105000382010f003082010a0282010100c57248c00c6231965b5cc158a62fe42b7b8e9b20a98ce963156760ba48083cfd61d48696039aaa17b9b603b0b595e679118653e657d059985f8f9cd76f20e4d39d79f56c5d8b9148008c371f9e0a56530e87a465c366f2cc4d223886361d6b44519d52444b0c13eea9b7bdbac0fc76a24562248debacba4838a07a1459e87b622756619627ef7dea7fd01f9e4cf90d545b366a73936575c47e887630fdee68084676705e08384b903d6c028dde98b3512af2adcc1988b8baa820b972e67817bbd40357a207ec5b9b9402c63a2920f71b0ce9c37d25f58ac860dc16fbd94167eadf3f7fed24bf1ab4d39e8019b37da2754aa51512025bfc7c79ed67f49a0ec5d10203010001"
                            Return $_
                        }
                    }
                }
                else
                {
                    $endpoints = $testEndpoints
                }
                Write-Output $endpoints
            }
        }

        # Test Parameter and Parameter Sets
        It "Should have the required  parameters and parameter sets" {
            (Get-Command Get-bConnectEndpoint).ParameterSets.Name | Should -Be 'ShowAll', 'Endpoint', 'OrgUnit', 'DynamicGroup', 'StaticGroup'
            (Get-Command Get-bConnectEndpoint).Parameters.Keys | Should -Be 'EndpointGuid', 'OrgUnitGuid', 'DynamicGroupGuid', 'StaticGroupGuid', 'PublicKey', 'IncludeSoftware', 'IncludeSnmpData', 'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable'
        }

        # Test Functionality of bConnect Endpoint
        it 'Should Query the Endpoints Controller without an Body Object if no Parameter is passed' {
            $output = Get-bConnectEndpoint
            'EndpointGuid' | Should -BeIn $output[0].PsObject.Properties.Name
            $output | ForEach-Object {$_.InstalledSoftware | Should -BeNullOrEmpty}
            $output | ForEach-Object {$_.PublicKey | Should -BeNullOrEmpty}
            $output.Count | Should -Be 10
            Assert-MockCalled 'Invoke-RestMethod' -ParameterFilter {$Uri -eq 'https://testserver/v1.0/Endpoints' } -Exactly 1 -Scope It
            Assert-MockCalled 'Invoke-RestMethod' -ParameterFilter {$Null -eq $Body } -Exactly 1 -Scope It
        }
        It 'Should Query the Endpoints Controller for an specific Endpoint' {
            $output = Get-bConnectEndpoint -EndpointGuid 'fddc25ca-284c-41ee-8a9c-1e04b95518f0'
            $output.EndpointGuid | Should -be 'fddc25ca-284c-41ee-8a9c-1e04b95518f0'
        }
        It 'Should Query the Endpoints Controller for an specific Endpoint with Installed Software Included' {
            $output = Get-bConnectEndpoint -EndpointGuid 'fddc25ca-284c-41ee-8a9c-1e04b95518f0' -IncludeSoftware
            $output | ForEach-Object {$_.PublicKey | Should -BeNullOrEmpty}
            $output.EndpointGuid | Should -be 'fddc25ca-284c-41ee-8a9c-1e04b95518f0'
            $output.InstalledSoftware.Count | Should -Be 2
        }
        It 'Should Query the Endpoints Controller for an specific Endpoint with Public Key Included' {
            $output = Get-bConnectEndpoint -EndpointGuid 'fddc25ca-284c-41ee-8a9c-1e04b95518f0' -PublicKey
            $output.EndpointGuid | Should -be 'fddc25ca-284c-41ee-8a9c-1e04b95518f0'
            $output | ForEach-Object {$_.InstalledSoftware | Should -BeNullOrEmpty}
            $output.PublicKey | Should -Be "40822422300d06092a864886f70d01010105000382010f003082010a0282010100c57248c00c6231965b5cc158a62fe42b7b8e9b20a98ce963156760ba48083cfd61d48696039aaa17b9b603b0b595e679118653e657d059985f8f9cd76f20e4d39d79f56c5d8b9148008c371f9e0a56530e87a465c366f2cc4d223886361d6b44519d52444b0c13eea9b7bdbac0fc76a24562248debacba4838a07a1459e87b622756619627ef7dea7fd01f9e4cf90d545b366a73936575c47e887630fdee68084676705e08384b903d6c028dde98b3512af2adcc1988b8baa820b972e67817bbd40357a207ec5b9b9402c63a2920f71b0ce9c37d25f58ac860dc16fbd94167eadf3f7fed24bf1ab4d39e8019b37da2754aa51512025bfc7c79ed67f49a0ec5d10203010001"
        }
        It 'Should Query the Endpoints Controller for all Endpoint in a specific OrgUnit' {
            $output = Get-bConnectEndpoint -OrgUnitGuid 'A2F076B4-DB5E-4598-B01E-B28A47E67DDD'
            $output | ForEach-Object {$_.InstalledSoftware | Should -BeNullOrEmpty}
            $output | ForEach-Object {$_.PublicKey | Should -BeNullOrEmpty}
            $output.count | Should -be 3
            'A2F076B4-DB5E-4598-B01E-B28A47E67DDD' | Should -BeIn $output.GuidOrgUnit
        }
        # While the Endpoint Object itself dosn't have any knowledge about its Group Membership
        # we're using the GuidOrgUnit as a filter in the Invoke-RestMethod Mock.
        # Although if the DynamicGroupGuid is a valid  Guid and a Parameter the REST API
        # should send us the correct entpoints
        It 'Should Query the Endpoints Controller for all Endpoint in a specific Dynamic Group' {
            $output = Get-bConnectEndpoint -DynamicGroupGuid '119BBA76-B01F-4EF7-8652-564AEBA53CCC'
            $output | ForEach-Object {$_.InstalledSoftware | Should -BeNullOrEmpty}
            $output | ForEach-Object {$_.PublicKey | Should -BeNullOrEmpty}
            $output.count | Should -be 2
            'fddc25ca-284c-41ee-8a9c-1e04b95518f6' | Should -BeIn $output.EndpointGuid
            'fddc25ca-284c-41ee-8a9c-1e04b95518f5' | Should -BeIn $output.EndpointGuid
        }
        # While the Endpoint Object itself dosn't have any knowledge about its Group Membership
        # we're using the GuidOrgUnit as a filter in the Invoke-RestMethod Mock.
        # Although if the StaticGroupGuid is a valid  Guid and a Parameter the REST API
        # should send us the correct entpoints
        It 'Should Query the Endpoints Controller for all Endpoint in a specific Static Group' {
            $output = Get-bConnectEndpoint -StaticGroupGuid 'DEC151FE-7BCE-43F2-8237-A34CBF196BBB'
            $output | ForEach-Object {$_.InstalledSoftware | Should -BeNullOrEmpty}
            $output | ForEach-Object {$_.PublicKey | Should -BeNullOrEmpty}
            $output.count | Should -be 2
            'fddc25ca-284c-41ee-8a9c-1e04b95518f3' | Should -BeIn $output.EndpointGuid
            'fddc25ca-284c-41ee-8a9c-1e04b95518f4' | Should -BeIn $output.EndpointGuid
        }
    }
}