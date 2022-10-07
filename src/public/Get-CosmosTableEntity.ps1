function Get-CosmosTableEntity {
    <#
    .SYNOPSIS
        Gets one or more entities from an Azure Storage/Cosmos Table.

    .DESCRIPTION
        Gets one or more entities from an Azure Storage/Cosmos Table.

    .INPUTS
        None

    .OUTPUTS
        None

    .EXAMPLE
        Get-CosmosTableEntity -UrlBase "nscherer-cosmos-table-test.table.cosmos.azure.com" -Table "Table" -AccessKey $AccessKey
        Returns all entities in the table.

        Get-CosmosTableEntity -UrlBase "nscherer-cosmos-table-test.table.cosmos.azure.com" -Table "Table" -AccessKey $AccessKey -PartitionKey "PKey" -RowKey "RowKey"
        Returns a specific entity in the table.
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$UrlBase,
        [Parameter(Mandatory=$true)]
        [string]$Table,
        [Parameter(Mandatory=$true)]
        [string]$AccessKey,
        [Parameter(Mandatory=$false)]
        [string]$PartitionKey,
        [Parameter(Mandatory=$false)]
        [string]$RowKey
    )

    $Table = [System.Web.HttpUtility]::UrlEncode($Table)
    $Method = "GET"
    $ApiEndpoint = "$Table"
    if ($RowKey) {
        $PartitionKey = [System.Web.HttpUtility]::UrlEncode($PartitionKey)
        $RowKey = [System.Web.HttpUtility]::UrlEncode($RowKey)
        $ApiEndpoint += "(PartitionKey='$PartitionKey',RowKey='$RowKey')"
    } else {
        $ApiEndpoint += "()"
    }

    $TableSplat = @{
        Headers = @{
            Authorization = Build-CosmosTableAuthHeader -UrlBase $UrlBase -ApiEndpoint $ApiEndpoint -AccessKey $AccessKey
            Date = Get-Date -Format R -AsUTC
            Accept = "application/json;odata=nometadata"
        }
        Uri = "https://$UrlBase/$ApiEndpoint"
        Method  = $Method
        ResponseHeadersVariable = "RestHeaders"
    }
    $RestReturn = Invoke-RestMethod @TableSplat
    if ($RestHeaders."x-ms-continuation-NextPartitionKey" -or $RestHeaders."x-ms-continuation-NextRowKey") {
        throw "This cmdlet can't currently handle more than 1000 rows in an Azure Storage table"
    }
    $RestReturn.Value
}