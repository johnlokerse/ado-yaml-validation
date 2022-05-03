Describe "YAML Validation" {
    BeforeAll { 
        [string] $organizationName = "john-lokerse"
        [string] $projectName = "Blog"
        [int] $pipelineId = 11
        [string] $yamlFilePath = "TestFiles\success.yml"
        [string] $personalAccessToken = $null

        $result = (.\Test-YamlADOPipeline.ps1 -OrganizationName $organizationName -ProjectName $projectName -PipelineId $pipelineId -YamlFilePath $yamlFilePath -PersonalAccessToken odrj7gyhrh7mq54eiyfnq2qslf33aqbpvexbxvgldjm3onglea3a)
    }

    It "Should contain a status code property" {
        $result | Should -BeLike "*StatusCode*"
    }

    It "Should contain a result message property" {
        $result | Should -BeLike "*ResultMessage*"
    }

    It "YAML validation should pass with StatusCode 200" {
        $result.StatusCode | Should -Be 200
    }
}