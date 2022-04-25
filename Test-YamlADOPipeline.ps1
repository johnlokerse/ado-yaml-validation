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
    # [ValidateScript({
    #         Write-Host $_
    #         if (-not ($_ | Test-Path)) {
    #             throw "File or Path does not exist."
    #         }

    #         if ($_ -notmatch "(\.yml)") {
    #             throw "The file specified in the path must be of type yml."
    #         }
    #     })]
    [string] $YamlFilePath,

    # Build Read & Execute permissions!
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $PersonalAccessToken
)

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

Invoke-RestMethod @Arguments