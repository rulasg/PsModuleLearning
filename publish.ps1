
[cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
param(
    # Update the module manifest with the version tag (Sample: v10.0.01-alpha)
    [Parameter(Mandatory=$false)] [string]$VersionTag,
    # PAT for the PSGallery
    [Parameter(Mandatory=$false)] [string]$NuGetApiKey,
    # DependencyInjection Ps1 file
    [Parameter(Mandatory=$false)] [scriptblock]$DependencyInjection
)

# Load helper 
# We Dot souce to allow all to be in the same scope as the sript
. ($PSScriptRoot | Join-Path -ChildPath "publish-Helper.ps1")
if ($DependencyInjection) { . $DependencyInjection }

# Process Tag
if($VersionTag){

    try {
        Update-PublishModuleManifest  $VersionTag 
    }
    catch {
        Write-Error -Message "Failed to update module manifest with version tag [$VersionTag]. Error: $_"
        exit 1
    }
}

# check that $NuggetApiKey is null or whitespace
# If it is use environment variable $env:NugetApiKey
if ( [string]::IsNullOrWhiteSpace($NuGetApiKey) ) {
    if ( [string]::IsNullOrWhiteSpace($env:NUGETAPIKEY) ) {
        # Write-Error -Message '$Env:NUGETAPIKEY is not set. Try running `$Env:NUGETAPIKEY = (Find-DocsFile nugetapikey | rsk | Get-SecretData).Get()`'
        Write-Error -Message '$Env:NUGETAPIKEY is not set. Please set the variable with a PSGallery PAT or use -NuGetApiKey parameter.'
        exit 1
    }
    $NuGetApiKey = $env:NUGETAPIKEY
}

# Publish module to PSGallery
# Invoke-PublishModuleToPSGallery -NuGetApiKey $NuGetApiKey -Force -WhatIf:$WhatIf
Invoke-PublishModuleToPSGallery -NuGetApiKey $NuGetApiKey -Force 

