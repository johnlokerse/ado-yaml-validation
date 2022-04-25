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

            if ($_ -notmatch "(\.yml)") {
                throw "The file specified in the path must be of type yml."
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
}