<#
.Synopsis
PsModuleLearning

.Description
Sample of module to learn

.Notes
NAME  : PsModuleLearning.psm1*
AUTHOR: rulasg

CREATED: 16/3/2023
#>

Write-Information "Loading PsModuleLearning ..."

$script:GuidInstance = 0

#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
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

# Here I might...
# Read in or create an initial config file and variable
# Export Public functions ($Public.BaseName) for WIP modules
# Set variables visible to the module and its functions only

Export-ModuleMember -Function Get-PublicFunction
Export-ModuleMember -Function Get-PublicFunctinWithPrivateCall
