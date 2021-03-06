# Reference: Az.CosmosDB | https://docs.microsoft.com/powershell/module/az.cosmosdb
# --------------------------------------------------
# Purpose
# Create Cosmos Table API account and a Table with autoscale throughput
# --------------------------------------------------
Function New-RandomString{Param ([Int]$Length = 10) return $(-join ((97..122) + (48..57) | Get-Random -Count $Length | ForEach-Object {[char]$_}))}
# --------------------------------------------------
$uniqueId = New-RandomString -Length 7 # Random alphanumeric string for unique resource names
$apiKind = "Table"
# --------------------------------------------------
# Variables - ***** SUBSTITUTE YOUR VALUES *****
$locations = @("East US", "West US") # Regions ordered by failover priority
$resourceGroupName = "mjbArmTest"#"myResourceGroup" # Resource Group must already exist
$accountName = "cosmos-$uniqueId" # Must be all lower case
$consistencyLevel = "Session"
$tableName = "myTable"
$autoscaleMaxThroughput = 4000 #minimum = 4000
# --------------------------------------------------
Write-Host "Creating account $accountName"
$account = New-AzCosmosDBAccount -ResourceGroupName $resourceGroupName `
    -Location $locations -Name $accountName -ApiKind $apiKind `
    -DefaultConsistencyLevel $consistencyLevel `
    -EnableAutomaticFailover:$true

Write-Host "Creating Table $tableName"
$table = New-AzCosmosDBTable -ParentObject $account `
    -Name $tableName -AutoscaleMaxThroughput $autoscaleMaxThroughput
