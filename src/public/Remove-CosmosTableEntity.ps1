function Remove-CosmosTableEntity {
    <#
    .SYNOPSIS
        Deletes an entity in an Azure Storage/Cosmos Table.

    .DESCRIPTION
        Deletes an entity in an Azure Storage/Cosmos Table.

    .INPUTS
        None

    .OUTPUTS
        None

    .EXAMPLE
        Remove-CosmosTableEntity -UrlBase "nscherer-cosmos-table-test.table.cosmos.azure.com" -Table "Table" -AccessKey $AccessKey -PartitionKey "PKey" -RowKey "RKey"
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
        [string]$RowKey
    )

    $Table = [System.Web.HttpUtility]::UrlEncode($Table)
    $PartitionKey = [System.Web.HttpUtility]::UrlEncode($PartitionKey)
    $RowKey = [System.Web.HttpUtility]::UrlEncode($RowKey)
    $Method = "DELETE"
    $ApiEndpoint = "$Table(PartitionKey='$PartitionKey',RowKey='$RowKey')"

    $TableSplat = @{
        Headers = @{
            Authorization = Build-CosmosTableAuthHeader -UrlBase $UrlBase -ApiEndpoint $ApiEndpoint -AccessKey $AccessKey
            Date = Get-Date -Format R -AsUTC
            "If-Match" = "*"
        }
        Uri = "https://$UrlBase/$ApiEndpoint"
        Method  = $Method
    }

    Invoke-RestMethod @TableSplat
}