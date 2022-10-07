function Update-CosmosTableEntity {
    <#
    .SYNOPSIS
        Updates an entity in an Azure Storage/Cosmos Table.

    .DESCRIPTION
        Updates an entity in an Azure Storage/Cosmos Table.

    .INPUTS
        None

    .OUTPUTS
        None

    .EXAMPLE
        Update-CosmosTableEntity -UrlBase "nscherer-cosmos-table-test.table.cosmos.azure.com" -Table "Table" -AccessKey $AccessKey -PartitionKey "PKey" -RowKey "RKey" -Data @{ Name = "Name" }
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$UrlBase,
        [Parameter(Mandatory=$true)]
        [string]$Table,
        [Parameter(Mandatory=$true)]
        [string]$AccessKey,
        [Parameter(Mandatory=$true)]
        [string]$PartitionKey,
        [Parameter(Mandatory=$true)]
        [string]$RowKey,
        [Parameter(Mandatory=$true)]
        [hashtable]$Data
    )

    $Table = [System.Web.HttpUtility]::UrlEncode($Table)
    $PartitionKey = [System.Web.HttpUtility]::UrlEncode($PartitionKey)
    $RowKey = [System.Web.HttpUtility]::UrlEncode($RowKey)
    $Method = "PUT"
    $ApiEndpoint = "$Table(PartitionKey='$PartitionKey',RowKey='$RowKey')"
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