#Resource Group Name
resource_group_name="resource_group_datalake_cosmos"

#Resource Group Location
location="centralus"

#VM Resource parameters
vm_name="ubuntu-18-dl"
private_ip_address_allocation="Dynamic"
vm_size="Standard_D2s_v3"

#VM Image parameters
storage_image_publisher="Canonical"
storage_image_offer="UbuntuServer"
storage_image_sku="18.04-LTS"
storage_image_version="latest"
osdisk_name="myosdisk"
osdisk_caching="ReadWrite"
osdisk_managed_disk_type="Standard_LRS"


#Storage Account Resource parameters
azurerm_storage_account_name = "sqlstorageaccountexample"
azurerm_storage_account_tier = "Standard"
azurerm_storage_account_repl_type = "LRS"
storage_acc_default_action ="Allow"
storage_acc_bypass = ["Metrics"]  
storage_account_access_key_is_secondary="true"
adls_name               = "exampleadls"

#CosmosDB
cosmosdb_account_name="cosmosdb-account-example"
cosmosdb_account_offer_type="Standard"
cosmosdb_account_kind="GlobalDocumentDB"
consistency_level="BoundedStaleness"
consistency_max_interval="10"
consistency_max_staleness_prefix="200"
geo_location_failover_priority="0"
azurerm_container_group_name="vote-aci-jan"
azurerm_container_group_ip_address_type="Private"
azurerm_container_group_dns_name_label="vote-aci-dns"
azurerm_container_group_os_type="linux"
azurerm_container_name="vote-aci-con"
azurerm_container_image="microsoft/azure-vote-front:cosmosdb"
azurerm_container_cpu="0.5"
azurerm_container_memory="1.5"
azurerm_container_port="80"
azurerm_container_protocol="TCP"
secure_environment_variables_title="Azure Voting App"
secure_environment_variables_value1="Cats"
secure_environment_variables_value2="Dogs"
cosmos_sql_db_throughput          = 400
cosmos_sql_db_name                = "example-cosmos-sql-db"
cosmos_sql_container_name = "example-cosmos-sql-container"
cosmos_container_partition_key_path    = "/definition/id"
cosmos_container_partition_key_version = 1

#Databricks Resource parameters
azurerm_databricks_workspace_name ="databrick-example-workspace"
azurerm_databricks_workspace_sku ="standard"

#Databricks Cluster parameters
databrick_cluster_name  = "Shared Autoscaling"
databrick_spark_version = "7.5.x-scala2.12"
worker_node_type_id  = "Standard_DS3_v2"
driver_node_type_id  = "Standard_DS3_v2"
cluster_min_workers = 1
cluster_max_workers = 2
cluster_autotermination_minutes = 120
cluster_num_workers = 1

#Datafactory Resource parameters
azurerm_data_factory_name ="datafactory-env"
adls_link_name                  = "adlinks"
link_cosmos_name = "examplecosmos"

df_cosmosql_dataset_name = "sqlcosmosdataset"
df_pipeline_name = "dfworkspacepiple"
df_trigger_name   = "dftrigger"
df_trigger_interval  = 5
df_trigger_frequency = "Day"


#Vault secret paths
vm_secret_path = "secret/LinuxVM"
azure_secret_path = "secret/azure"
sql_secret_path = "secret/SQLdatabase"

#Network Resource parameters
subnet_address_prefixes1="10.0.0.0/24"
subnet_address_prefixes2="10.0.1.0/24"
subnet_address_prefixes3="10.0.2.0/24"
azurerm_public_ip_name="mypublicip"
vnet_name="tfvnet"

#VM Resource parameters
ip_configuration_name="exampleconfiguration"
vn_address_space="10.0.0.0/16"

#Cosmos Account Ip Range
ip_range_cosmos_acc = "0.0.0.0"
cosmos_container_nwf_name = "examplenic"
cosmos_ip_configuration_name      = "exampleipconfig"
