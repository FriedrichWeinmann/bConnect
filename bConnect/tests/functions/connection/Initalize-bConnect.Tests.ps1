InModuleScope bConnect {

    #region Test Parameter
    $testPasswd = ConvertTo-SecureString "PesterTestPassword" -AsPlainText -Force
    $testCreds = New-Object System.Management.Automation.PSCredential ("TestUser", $testPasswd)
    $testServer = "testserver"
    $moduleName = "bConnect"
    #end region


    Describe 'Initalize bConnect Unit Test' {

        beforeEach {
            Mock  Invoke-RestMethod {
                if ($testCreds -ne $Credential)
                {
                    Throw "The remote server returned an error: (403) Forbidden"
                }
                elseif ($Uri -ne "https://$testServer/bConnect/info")
                {
                    Throw "The remote name could not be resolved: $Uri"
                }
                else
                {
                    Return @{
                        bConnectVersion = "1.0"
                        bMSVersion      = "18.1.43.0"
                    }
                }
            }
        }

        it 'Throws an Error when the Server FQDN is wrong' {
            $wrongServer = 'WrongServer'
            {Initialize-bConnect -Server $wrongServer -Credentials $testCreds} | Should Throw 'Error while initalizing the bConnect Module'
            Assert-MockCalled 'Invoke-RestMethod' -ParameterFilter {$Uri -eq "https://$wrongServer/bConnect/info" } -Exactly 1 -Scope It

        }
        it 'Throws an Error when the Credentials are wrong' {
            $wrongPasswd = ConvertTo-SecureString "WrongPassword" -AsPlainText -Force
            $wrongCreds = New-Object System.Management.Automation.PSCredential ("TestUser", $testPasswd)
            {Initialize-bConnect -Server "$testServer" -Credentials $wrongCreds} | Should Throw 'Error while initalizing the bConnect Module'
            Assert-MockCalled 'Invoke-RestMethod' -ParameterFilter {$Uri -eq "https://$testServer/bConnect/info" } -Exactly 1 -Scope It

        }
        # Catch any Problems with the Connection Functions to bConnect
        it 'Checks Initalize Connection for bConnect Module' {
            Initialize-bConnect -Server "$testServer" -Credentials $testCreds

            $script:_connectInitialized | Should -be $true
            $script:_connectUri | Should -be 'https://testserver:443/bConnect'
            $script:_connectCredentials | Should -be $testCreds

            Assert-MockCalled 'Invoke-RestMethod' -ParameterFilter {$Uri -eq "https://$testServer/bConnect/info" } -Exactly 2 -Scope It
        }
        it "Get-bConnectInfo CmdLet should Return an Object with Version Information" {
            $bConnectInfo = Get-bConnectInfo
            $bConnectInfo.bConnectVersion | Should -be '1.0'
            $bConnectInfo.bMSVersion | Should -Be '18.1.43.0'
            # No Api Call Should be necessary because the Info is stored in a Variable during the session
            Assert-MockCalled 'Invoke-RestMethod' -ParameterFilter {$Uri -eq "https://$testServer/bConnect/info" } -Exactly 0 -Scope It
        }
        it "Get-bConnectVersion should Return a System.Version Object of bConnectVersion" {
            $bConnectVersion = Get-bConnectVersion
            $bConnectVersion | Should -be '1.0'
            $bConnectVersion | Should -BeOfType [System.Version]
            # No Api Call Should be necessary because the Info is stored in a Variable during the session
            Assert-MockCalled 'Invoke-RestMethod' -ParameterFilter {$Uri -eq "https://$testServer/bConnect/info" } -Exactly 0 -Scope It
        }
        it "Get-bConnectVersion should Query the API if the cache Variable is empty" {
            $script:_bConnectInfo = $Null
            $bConnectVersion = Get-bConnectVersion
            $bConnectVersion | Should -be '1.0'
            $bConnectVersion | Should -BeOfType [System.Version]
            Assert-MockCalled 'Invoke-RestMethod' -ParameterFilter {$Uri -eq "https://$testServer/bConnect/info" } -Exactly 1 -Scope It
        }
        it "Get-bConnectVersion -bMSVersion should Return a System.Version Object of the BMSVersion" {
            $bmsVersion = Get-bConnectversion -bMSVersion
            $bmsVersion | Should -be '18.1.43.0'
            $bmsVersion | Should -BeOfType [System.Version]
            # No Api Call Should be necessary because the Info is stored in a Variable during the session
            Assert-MockCalled 'Invoke-RestMethod' -ParameterFilter {$Uri -eq "https://$testServer/bConnect/info" } -Exactly 0 -Scope It
        }
    }
}