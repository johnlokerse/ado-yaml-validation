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
        })]
    [string] $YamlFilePath
)


$Body = @{
    "PreviewRun"   = "true"
    "YamlOverride" = 
    '
pool:
  vmImage: windows-2019
  
jobs:
 - job: Run_PowerShell_Write_Host
   steps:
     - task: PowerShell@2
       inputs:
         targetType: "inline"
         script: |
          Write-Host "Hello World"
'
}

$OrganizationName = "john-lokerse"
$ProjectName = "Blog"
$PipelineId = 11
$Url = "https://dev.azure.com/$OrganizationName/$ProjectName/_apis/pipelines/$PipelineId/runs?api-version=5.1-preview"

$Arguments = @{
    Method      = "POST"
    Uri         = $Url
    Body        = $Body | ConvertTo-Json
    ContentType = "application/json"
    Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":<YOUR_PAT_HERE>")) }
}

Invoke-RestMethod @Arguments