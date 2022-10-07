function Build-CosmosTableAuthHeader {
    <#
    .SYNOPSIS
        Creates a header to authenticate to Azure Storage/Cosmos Tables.

    .DESCRIPTION
        Creates a header to authenticate to Azure Storage/Cosmos Tables.

    .INPUTS
        None

    .OUTPUTS
        None

    .EXAMPLE
        Build-CosmosTableAuthHeader -UrlBase "nscherer-cosmos-table-test.table.cosmos.azure.com" -ApiEndpoint $ApiEndpoint -AccessKey $AccessKey
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UrlBase,
        [Parameter(Mandatory = $true)]
        [string]$ApiEndpoint,
        [Parameter(Mandatory = $true)]
        [string]$AccessKey
    )

    $HmacSha = New-Object System.Security.Cryptography.HMACSHA256
    $AccountName = $UrlBase.Split(".")[0]
    $DateTime = Get-Date -Format r -AsUtc
    $DecodedKeyBytes = [System.Convert]::FromBase64String($AccessKey)

    $CanonicalizedResource = "/$AccountName/$ApiEndpoint"
    $StringToSign = "$DateTime`n$CanonicalizedResource"

    $HmacSha.key = $DecodedKeyBytes
    $Signature = $HmacSha.ComputeHash([Text.Encoding]::UTF8.GetBytes($StringToSign))
    $SignatureBase64 = [Convert]::ToBase64String($Signature)

    $Header = "SharedKeyLite $($AccountName):$SignatureBase64"
    $Header
}