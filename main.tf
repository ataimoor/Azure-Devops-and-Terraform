provider "azurerm" {
    version = "2.5.0"
    features{}
}

terraform {
    backend "azurerm" {
        resource_group_name = "tf_rgrp_blobstore"
        storage_account_name = "tfstoreterraform"
        container_name       = "tfstate"
        key                 =   ""   
    }
}

variable "imagebuild" {
  type      = string
  description = "Latest image build"
}


resource "azurerm_resource_group" "tf_test" {
    name = "tfmainrg"
    location = "westus"
}

resource "azurerm_container_group" "tfcg_test" {
    name                        = "weatherapi"
    location                    =azurerm_resource_group.tf_test.location
    resource_group_name         =azurerm_resource_group.tf_test.name

    ip_address_type             = "public"
    dns_name_label              = "weatherapiwa"
    os_type                     = "Linux"

    container {
        name                    = "weatherapi"
            image                   = "ataimoor/weatherapi:${var.imagebuild}"
            cpu                     = "1"
            memory                  = "1"

        ports{
            port                = 80
            protocol            = "TCP"
        }
    }
}