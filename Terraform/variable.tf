variable "data_resource_group_name" {
  type = string
  default = "example-Terraform"
}

variable "data_vnet_name" {
  type = string
  default = "tfvnet"
}
variable "data_subnet_name" {
  type = string
  default = "internal"
}
variable "data_public_subnet_name" {
  type = string
  default = "publicsubnet"
}
variable "data_private_subnet_name" {
  type = string
  default = "privatesubnet"
}


variable "azurerm_public_ip_name" {
  description = "Public IP Name."
}

variable "vnet_name" {
    description = "Name of the virtual network to create"
    default     = "tfvnet"
}

variable "vm_name" {
    description = "Name of the virtual machine to create"
    default     = "tfvm"
}

variable "ip_configuration_name" {
    description = "Name of the IP Configuration to create"

}
variable "osdisk_name" {
    description = "Name of the virtual machine to create"
    default     = "myosdisk"
}




variable "private_ip_address_allocation"{
  default="Dynamic"
  description="IP configuration private ip address allocation"
}

variable "public_ip_address_allocation"{
  default="Dynamic"
  description="IP configuration public ip address allocation"
}

variable "vm_size" {
  default="Standard_F2"
  description="VM Size"
}

variable "storage_image_publisher"{
  default="Canonical"
  description="Storage Image Publisher"
}

variable "storage_image_offer" {
  default="UbuntuServer"
  description="Storage Image Publisher offer"
}

variable "storage_image_sku" {
  default="16.04-LTS"
  description="Storage Image Publisher sku"
}

variable "storage_image_version" {
  default="latest"
  description="Storage Image Publisher version"
}

variable "osdisk_caching" {
  default="ReadWrite"
  description="Storage OS Disk caching"
}



variable "osdisk_managed_disk_type"{
  default="Standard_LRS"
  description="Managed Disk Type"
}



variable "osprofile_admin_username"{
  default="testadmin"
  description="Admin Username"
}



variable "azurerm_storage_account_name" {
  type = string
  description = "Storage account name"
}


variable "azurerm_storage_account_tier" {
  type = string
  description = "storage account tier"
}

variable "azurerm_storage_account_repl_type" {
  type = string
  description = "storage account replication type"
}


variable "storage_account_access_key_is_secondary"{
  description = "Storage Account Access Key is Secondary"
}

variable "azurerm_databricks_workspace_name" {
  type = string
  description = "databricks workspace name"
}

variable "azurerm_databricks_workspace_sku" {
  type = string
  description = "Databricks workspace sku value"
}
variable "databrick_cluster_name" {
  type = string
}
variable "databrick_spark_version" {
  type = string
}
variable "worker_node_type_id" {
  type = string
}
variable "driver_node_type_id" {
  type = string
}
variable "cluster_min_workers" {
  type = number
}
variable "cluster_max_workers" {
  type = number
}
variable "cluster_autotermination_minutes" {
  type = number
}


variable "storage_acc_bypass" {
  type  = list(string)
}


variable "storage_acc_default_action" {
  type = string
}

variable "vm_secret_path" {
  type = string
}

variable "azurerm_data_factory_name" {
  type = string
  description = "Azure data factory name"
}
variable "azure_secret_path" {
  type = string
  description = "Azure secret path of vault data"
}
variable "sql_secret_path" {
  type = string
  description = "Resource group name"
}


variable "link_cosmos_name" {
  type = string
}

variable "ip_range_cosmos_acc" {
  type = string
}

variable "prefix" {
  default="cosmosdemo"
  description = "The prefix which should be used for all resources in this example"
}

variable "cosmosdb_account_name" {
  default="cosmosdb_account1"
  description = "CosmosDB Account Name"
}
variable "cosmosdb_account_offer_type" {
  default="Standard"
  description = "Offer type for cosmosdb account"
}

variable "cosmosdb_account_kind" {
  default="GlobalDocumentDB"
  description = "CosmosDB account kind"
}
variable "consistency_level" {
  default="BoundedStaleness"
  description = "Consistency Level"
}
variable "consistency_max_interval" {
  default="10"
  description = "Consistency Max Interval in Sec"
}
variable "consistency_max_staleness_prefix" {
  default="200"
  description = "Consistency Max Staleness Prefix"
}
variable "geo_location_failover_priority" {
  default="0"
  description = "Geo Location Failover Priority"
}
variable "azurerm_container_group_name" {
  default="vote-aci"
  description = "Container Group Name"
}
variable "azurerm_container_group_ip_address_type" {
  default="public"
  description = "Container Group IP Address Type"
}
variable "azurerm_container_group_dns_name_label" {
  default="vote-aci"
  description = "Container Group DNS Name Label"
}
variable "azurerm_container_group_os_type" {
  default="linux"
  description = "Container Group OS Type"
}
variable "azurerm_container_name" {
  default="vote-aci"
  description = "Azure Container Name"
}
variable "azurerm_container_image" {
  default="microsoft/azure-vote-front:cosmosdb"
  description = "Azure Container Image"
}
variable "azurerm_container_cpu" {
  default="0.5"
  description = "Azure Container CPU"
}
variable "azurerm_container_memory" {
  default="1.5"
  description = "Azure Container Memory"
}
variable "azurerm_container_port" {
  default="80"
  description = "Azure Container Port"
}
variable "azurerm_container_protocol" {
  default="TCP"
  description = "Azure Container Protocol"
}
variable "secure_environment_variables_title" {
  default="Azure Voting App"
  description = "Secure Environment Variable Title"
}
variable "secure_environment_variables_value1" {
  default="Cats"
  description = "Secure Environment Variable Value1"
}
variable "secure_environment_variables_value2" {
  default="Dogs"
  description = "Secure Environment Variable Value2"
}

variable "cosmos_sql_db_throughput" {
  type = number
}
variable "cosmos_sql_db_name" {
  type = string
}



variable "df_cosmosql_dataset_name" {
  type = string
}
variable "df_pipeline_name" {
  type = string
}

variable "df_trigger_interval" {
  type = number
}

variable "df_trigger_name" {
  type = string
}
variable "df_trigger_frequency" {
  type = string
}

variable "adls_name" {
  type = string
}
variable "adls_link_name" {
  type = string
}
variable "cosmos_container_nwf_name" {
  type = string
}
variable "cosmos_ip_configuration_name" {
  type = string
}
variable "cluster_num_workers" {
  type = number
}
variable "cosmos_sql_container_name" {
  type = string
}
variable "cosmos_container_partition_key_path" {
  type = string
}
variable "cosmos_container_partition_key_version" {
  type = number
}
