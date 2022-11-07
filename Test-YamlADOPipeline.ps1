<#
.SYNOPSIS
    Performs actions to validate the given YAML file in Azure DevOps using an official Microsoft API.
.EXAMPLE
    PS> .\Test-YamlADOPipeline.ps1 -OrganizationName my-org-name -ProjectName my-project-name -PipelineId 24 -YamlFilePath TestFiles/test.yml -PersonalAccessToken dSRjMqskBhxWlKwUOEGJzbYNLVmeXfaHATgZDcnoupIFPivCytQr

    Validates the given YAML file on an existing pipeline definition (PAT is an example and randomized)
.PARAMETER OrganizationName
    This describes name of the Azure DevOps organization name. [string]
.PARAMETER ProjectName
    This describes name of the project. [string]
.PARAMETER PipelineId
    This describes the definition id of the pipeline where the YAML needs to be validated. [int]
.PARAMETER YamlFilePath
    This describes the path to the YAML file (e.g. ./TestFiles/test.yml). [string]
.PARAMETER PersonalAccessToken
    This describes the authentication token for Azure DevOps. [string]
#>
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $OrganizationName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $ProjectName,

    [Parameter(Mandatory = $true)]
    [int] $PipelineId,

    [Parameter(Mandatory = $true)]
    [ValidateScript({
            if (-not ($_ | Test-Path)) {
                throw "File or Path does not exist."
            }

            if ($_ -notmatch "(\.ya?ml)") {
                throw "The file specified in the path must be of type yml or yaml."
            }

            return $true
        })]
    [string] $YamlFilePath,

    # Build Read & Execute permissions!
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $PersonalAccessToken
)

function Add-CustomObjectProperties {
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject] $Object
    )

    if ($null -ne $Object) {
        $Object | Add-Member -MemberType NoteProperty -Name "ResultMessage" -Value "Validation success"
        $Object | Add-Member -MemberType NoteProperty -Name "StatusCode" -Value "200"
        return $Object
    }
}

$content = @"
$(Get-Content -Raw $YamlFilePath)
"@
$Body = @{
    "PreviewRun"   = "true"
    "YamlOverride" = $content
}

$Url = "https://dev.azure.com/$OrganizationName/$ProjectName/_apis/pipelines/$PipelineId/runs?api-version=5.1-preview"

$Arguments = @{
    Method      = "POST"
    Uri         = $Url
    Body        = $Body | ConvertTo-Json
    ContentType = "application/json"
    Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PersonalAccessToken)")) }
}

try {
    [PSCustomObject] $restOutput = Invoke-RestMethod @Arguments
    Add-CustomObjectProperties -Object $restOutput
}
catch {
    Write-Error ($_.ErrorDetails.Message | ConvertFrom-Json).Message
    exit 1
}
