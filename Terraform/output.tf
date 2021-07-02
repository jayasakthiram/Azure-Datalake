#----------------------------------------OUTPUTS------------------------------------------




#----------------------------------------------------------------------------------------
output "VM_PUBLIC_IP_ADDRESS" {
 value = azurerm_linux_virtual_machine.azure_vm.public_ip_address
 description = "The public IP address of the VM instance."
}

output "VM_ADMIN_USERNAME" {
 value = azurerm_linux_virtual_machine.azure_vm.admin_username
 description = "The VM username to access"
}
output "VM_ADMIN_PASSWORD" {
 value = azurerm_linux_virtual_machine.azure_vm.admin_password
 description = "The VM username to access"
}


output "STORAGE_ACCOUNT_NAME" {
 value = azurerm_storage_account.sql_storage_acnt.name
 description = "SQL Storage Account Name "
}


output "DATABRICKS_MANAGED_RESOURCE_NAME" {
 value = azurerm_databricks_workspace.databricks.managed_resource_group_name
 description = "Azure Databricks managed resource group name"
}

output "DATABRICKS_URL" {
 value = "https://${azurerm_databricks_workspace.databricks.workspace_url}/aad/auth?has=&Workspace=${azurerm_databricks_workspace.databricks.id}&WorkspaceResourceGroupUri=${azurerm_databricks_workspace.databricks.managed_resource_group_id}"
 description = "Azure Databricks workspace URL "
}
output "DATABRICKS_CLUSTER_NAME" {
 value = databricks_cluster.shared_autoscaling.cluster_name 
 description = "Azure Databricks Cluster name"
}
output "DATABRICKS_CLUSTER_SPARK_VERSION" {
 value = databricks_cluster.shared_autoscaling.spark_version 
 description = "Azure Databricks Cluster Spark version"
}

output "DATAFACTORY_URL" {
 value = "https://adf.azure.com/en-us/home?factory=${azurerm_data_factory.dataFactory.id}&l=en-us"
 description = "Azure Databricks workspace URL "
}

output "COSMOSDB_ACCOUNT_NAME" {
 value = azurerm_cosmosdb_account.cosmosDB.name
 description = "CosmosDB Account Name"
}
output "COSMOSDB_SQL_DATABASE_NAME" {
 value = azurerm_cosmosdb_sql_database.cosmos_sql_db.name
 description = "CosmosDB SQL database"
}

output "COSMOSDB_URL" {
 value = "https://cosmos.azure.com/"
 description = "CosmosDB Data explorer URL"
}
output "COSMOSDB_CONNECTION_STRING_READ-WRITE" {
 value = azurerm_cosmosdb_account.cosmosDB.connection_strings.0
 description = "CosmosDB Data explorer connection string for read/write"
}
output "COSMOSDB_CONNECTION_STRING_READ-ONLY" {
 value = azurerm_cosmosdb_account.cosmosDB.connection_strings.2
 description = "CosmosDB Data explorer connection string for read only"
}

