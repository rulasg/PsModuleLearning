<#
.Synopsis
DemoPsModuleTest

.Description
Testing module for DemoPsModule

.Notes
NAME  : DemoPsModuleTest.psm1*
AUTHOR: rulasg

CREATED: 16/3/2023
#>

Write-Information "Loading DemoPsModuleTest ..."

# function for dependency injection

function ImportTestingPrivateFunctions{

    $module = Get-Module -Name DemoPsModule

    & $module {
        $path = Join-Path -Path $PSScriptRoot -ChildPath "private"
        $Private = @( Get-ChildItem -Path $path -ErrorAction SilentlyContinue )
        Foreach($import in $Private)
        {
            Try
            {
                . $import.fullname
            }
            Catch
            {
                Write-Error -Message "Failed to import function $($import.fullname): $_"
            }
        }
    }
} Export-ModuleMember -Function Import-PrivateFunctions

function DemoPsModuleTest_Sample(){
    Assert-IsTrue -Condition $true
}

function DemoPsModuleTest_GetPrivateFunction(){

    # $module = Import-Module -Name $MODULE_PATH -PassThru -Force
    $module = Get-Module -Name DemoPsModule

    & $module {

        $result = Get-PrivateFunction -Text "Testing"
        Assert-AreEqual -Expected ("Private function [{0}]" -f "Testing") -Presented $result
    }
}

function DemoPsModuleTest_GetPublicFunction(){

    $result = Get-PublicFunction -Text "Testing"

    Assert-AreEqual -Expected ("Public function [{0}]" -f "Testing") -Presented $result
}

function DemoPsModuleTest_GetPublicFunctionWithPrivateCall(){

    $result = Get-PublicFunctinWithPrivateCall -Text "Testing"

    Assert-AreEqual -Expected ("Public function [{0}]" -f "Private function [Testing]") -Presented $result
}

function DemoPsModuleTest_GetPublicFunctionWithPrivateCall_Injected(){

    $result_Pub1 = Get-PublicFunctinWithPrivateCall -Text "Testing"
    Assert-AreEqual -Expected ("Public function [{0}]" -f "Private function [Testing]") -Presented $result_Pub1

    ImportTestingPrivateFunctions

    $result_Pub2 = Get-PublicFunctinWithPrivateCall -Text "Testing"
    Assert-AreEqual -Expected ("Public function [{0}]" -f "Injected Private function [Testing]") -Presented $result_Pub2
}

Export-ModuleMember -Function DemoPsModuleTest_*