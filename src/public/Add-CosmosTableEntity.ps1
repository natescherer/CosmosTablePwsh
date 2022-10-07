function Add-CosmosTableEntity {
    <#
    .SYNOPSIS
        Adds an entity to an Azure Storage/Cosmos Table.

    .DESCRIPTION
        Adds an entity to an Azure Storage/Cosmos Table.

    .INPUTS
        None

    .OUTPUTS
        None

    .EXAMPLE
        Add-CosmosTableEntity -UrlBase "nscherer-cosmos-table-test.table.cosmos.azure.com" -Table "Table" -AccessKey $AccessKey -Data @{ PartitionKey = "PKey"; RowKey = "RKey"; Name = "Name" }
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$UrlBase,
        [Parameter(Mandatory=$true)]
        [string]$Table,
        [Parameter(Mandatory=$true)]
        [string]$AccessKey,
        [Parameter(Mandatory = $true)]
        [hashtable]$Data
    )

    $Table = [System.Web.HttpUtility]::UrlEncode($Table)
    $Method = "POST"
    $ApiEndpoint = "$Table"
    $BodyJson = ConvertTo-Json -InputObject $Data

    $TableSplat = @{
        Headers = @{
            Authorization = Build-CosmosTableAuthHeader -UrlBase $UrlBase -ApiEndpoint $ApiEndpoint -AccessKey $AccessKey
            Date = Get-Date -Format R -AsUTC
            Accept = "application/json;odata=nometadata"
        }
        ContentType = "application/json"
        Uri = "https://$UrlBase/$ApiEndpoint"
        Method  = $Method
        Body = $BodyJson
    }

    Invoke-RestMethod @TableSplat
}