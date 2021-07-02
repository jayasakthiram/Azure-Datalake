#------------------------------------------------------------------------------------------------------------------------------------------
#Description: This script is used to provision  a Azure Datalake platform
#usage: Intializing a new Terraform template --> terraform init 
#       Customising deploument with variables --> terraform plan     OR         --> terraform plan -var="variable=value" (for including variables straight from the command line)
#       plan,apply or destroy                --> terraform apply      OR    --> terraform apply value (if we have stored  for any output value )
#output: Creates AzureVM, ADLS gen v2 Storage, Cosmos DB, Databricks, Azure Datafactory
#Owner: Dark Angel
#tester: White Devil
#---------------------------------------------------------------------------------------------------------------------------------------------

#Define the Providers
terraform {
  required_providers {
  databricks = {
    source = "databrickslabs/databricks"
    version = "0.2.9"
    }
  }
}

#Define the Vault Provider
provider "vault" {
}

#Datasources from Vault secret engine
#Azure secrets contains service principle credentials
data "vault_generic_secret" "azure_auth" {
  path = var.azure_secret_path
}
#VM authentication secrets contains SSH keys
data "vault_generic_secret" "vm_auth" {
  path = var.vm_secret_path
}

#Database admin_creds holds the administrator credential keys
data "vault_generic_secret" "admin_creds" {
  path = var.sql_secret_path
}


#Define the Azure provider
provider "azurerm" {
  features {}
  subscription_id = data.vault_generic_secret.azure_auth.data["subscription_id"]
  tenant_id       = data.vault_generic_secret.azure_auth.data["tenant_id"]
  client_id       = data.vault_generic_secret.azure_auth.data["client_id"]
  client_secret   = data.vault_generic_secret.azure_auth.data["client_secret"]
}

#Using Existing Resource group
data "azurerm_resource_group" "existing_rg" {
  name = var.data_resource_group_name
}
#Using Existing Virtual network
data "azurerm_virtual_network" "existing_vnet" {
  name                = var.data_vnet_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}
#Using Existing Subnet
data "azurerm_subnet" "existing_subnet" {
  name                 = var.data_subnet_name
  virtual_network_name    = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

#Using Pre-defined Public subnet
data "azurerm_subnet" "existing_public_subnet" {
  name                 = var.data_public_subnet_name
  virtual_network_name    = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

#Using Pre-defined Private Subnet
data "azurerm_subnet" "existing_private_subnet" {
  name                 = var.data_private_subnet_name
  virtual_network_name    = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}


#Creating public Ip for VM
resource "azurerm_public_ip" "vm_public_ip" {
    name                         = "${var.azurerm_public_ip_name}-pip"
    location            = data.azurerm_resource_group.existing_rg.location
    resource_group_name = data.azurerm_resource_group.existing_rg.name
    allocation_method            = var.public_ip_address_allocation

}


#Creating a network interface for VM
resource "azurerm_network_interface" "main" {
  name                = "${var.vm_name}-nic"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name

  ip_configuration {
    name                          = "${var.ip_configuration_name}"
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id           = azurerm_public_ip.vm_public_ip.id 
 }
}


#Creating a Linux VM
resource "azurerm_linux_virtual_machine" "azure_vm" {
  name                = "${var.vm_name}-vm"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  size                = var.vm_size
  admin_username      = data.vault_generic_secret.vm_auth.data["administrator_login"]
  admin_password = data.vault_generic_secret.vm_auth.data["administrator_login_password"]
  disable_password_authentication = false
  network_interface_ids = ["${azurerm_network_interface.main.id}"]

  os_disk {
    name                 = "${var.osdisk_name}"
    caching              = var.osdisk_caching
    storage_account_type = var.osdisk_managed_disk_type
  }

  source_image_reference {
    publisher = var.storage_image_publisher
    offer     = var.storage_image_offer
    sku       = var.storage_image_sku
    version   = var.storage_image_version
  }
}

#Creating a Storgae account
resource "azurerm_storage_account" "sql_storage_acnt" {
  name                     = var.azurerm_storage_account_name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  account_tier             = var.azurerm_storage_account_tier
  account_replication_type = var.azurerm_storage_account_repl_type
}
#Creating a ADLS gen 2 container
resource "azurerm_storage_data_lake_gen2_filesystem" "dl_storage" {
  name               = var.adls_name
  storage_account_id = azurerm_storage_account.sql_storage_acnt.id
}



#Creating network rules for storage account
resource "azurerm_storage_account_network_rules" "storage_rule" {
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  storage_account_name = azurerm_storage_account.sql_storage_acnt.name
  default_action             = var.storage_acc_default_action
  virtual_network_subnet_ids = [data.azurerm_subnet.existing_subnet.id]
  bypass                     = var.storage_acc_bypass
}

#Creating a CosmosDB
resource "azurerm_cosmosdb_account" "cosmosDB" {
  name                = var.cosmosdb_account_name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  offer_type          = var.cosmosdb_account_offer_type
  kind                = var.cosmosdb_account_kind
  ip_range_filter  = var.ip_range_cosmos_acc
  consistency_policy {
    consistency_level       = var.consistency_level
    max_interval_in_seconds = var.consistency_max_interval
    max_staleness_prefix    = var.consistency_max_staleness_prefix
  }

  geo_location {
    prefix            = "${var.prefix}-customid"
    location            = data.azurerm_resource_group.existing_rg.location
    failover_priority = var.geo_location_failover_priority
  }

  is_virtual_network_filter_enabled="true"

  virtual_network_rule{
  id = data.azurerm_subnet.existing_subnet.id
  }
}



#Creating cosmos sql db
resource "azurerm_cosmosdb_sql_database" "cosmos_sql_db" {
  name                = var.cosmos_sql_db_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  account_name        = azurerm_cosmosdb_account.cosmosDB.name
  throughput          = var.cosmos_sql_db_throughput
}


#Creating cosmos sql container
resource "azurerm_cosmosdb_sql_container" "cosmos_sql_container" {
  name                  = var.cosmos_sql_container_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  account_name        = azurerm_cosmosdb_account.cosmosDB.name
  database_name         = azurerm_cosmosdb_sql_database.cosmos_sql_db.name
  throughput          = var.cosmos_sql_db_throughput
  partition_key_path    = var.cosmos_container_partition_key_path
  partition_key_version = var.cosmos_container_partition_key_version
}


#Creating a datafactory resource
resource "azurerm_data_factory" "dataFactory" {
  name                = var.azurerm_data_factory_name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}


#Creating Linked service for ADLS Storage
resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "dl_link" {
  name                  = var.adls_link_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  data_factory_name   = azurerm_data_factory.dataFactory.name
  service_principal_id  = data.vault_generic_secret.azure_auth.data["client_id"]
  service_principal_key = data.vault_generic_secret.azure_auth.data["client_secret"]
  tenant                = data.vault_generic_secret.azure_auth.data["tenant_id"]
  url                   = "https://${azurerm_storage_account.sql_storage_acnt.name}.dfs.core.windows.net"
}


#creating a cosmosdb linked service
resource "azurerm_data_factory_linked_service_cosmosdb" "cosmos_link" {
  name                = var.link_cosmos_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  data_factory_name   = azurerm_data_factory.dataFactory.name
  account_endpoint    = azurerm_cosmosdb_account.cosmosDB.endpoint
  account_key         = azurerm_cosmosdb_account.cosmosDB.primary_master_key
  database            = var.cosmos_sql_db_name
}



#Creating dataset on Cosmos SQL API
resource "azurerm_data_factory_dataset_cosmosdb_sqlapi" "sqldataset" {
  name                = var.df_cosmosql_dataset_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  data_factory_name   = azurerm_data_factory.dataFactory.name
  linked_service_name = azurerm_data_factory_linked_service_cosmosdb.cosmos_link.name

}
#Creating Datafactory pipeline
resource "azurerm_data_factory_pipeline" "df_pipeline" {
  name                = var.df_pipeline_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  data_factory_name   = azurerm_data_factory.dataFactory.name
}
#Creating Trigger for pipeline
resource "azurerm_data_factory_trigger_schedule" "day_trigger" {
  name                = var.df_trigger_name 
  data_factory_name   = azurerm_data_factory.dataFactory.name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  pipeline_name       = azurerm_data_factory_pipeline.df_pipeline.name

  interval  = var.df_trigger_interval 
  frequency = var.df_trigger_frequency 
}

#Creating a databricks workspace
resource "azurerm_databricks_workspace" "databricks" {
  name                = var.azurerm_databricks_workspace_name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  sku                 = var.azurerm_databricks_workspace_sku
  custom_parameters {
           private_subnet_name = data.azurerm_subnet.existing_private_subnet.name
           public_subnet_name  = data.azurerm_subnet.existing_public_subnet.name
           virtual_network_id  = data.azurerm_virtual_network.existing_vnet.id
        }
}

#Creating Databrick provider
provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.databricks.id
  azure_client_id             = data.vault_generic_secret.azure_auth.data["client_id"]
  azure_client_secret         = data.vault_generic_secret.azure_auth.data["client_secret"]
  azure_tenant_id             = data.vault_generic_secret.azure_auth.data["tenant_id"]
}

#Creating a Databrick spark cluster
resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = var.databrick_cluster_name
  spark_version           = var.databrick_spark_version
  node_type_id            = var.worker_node_type_id
  driver_node_type_id     = var.driver_node_type_id
  autotermination_minutes = var.cluster_autotermination_minutes
  num_workers = var.cluster_num_workers
}



