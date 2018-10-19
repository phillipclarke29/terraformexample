provider "azurerm"{
 subscription_id = "fa8f947d-8f9d-437f-9eca-efdf91510398"
 client_id = "21c1ba0b-a1a3-4145-a931-cc330fb8b9ff"
 client_secret ="8aa4ab99-01ed-45cd-9066-fe99bc489090"
 tenant_id = "8dddc7b3-447c-4a66-ae9e-4b6e8ddf6e75"
}



# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "myterraformgroup" {
    name     = "myResourceGroup"
    location = "eastus"

    tags {
        environment = "Terraform Demo"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

    tags {
        environment = "Terraform Demo"
    }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "mySubnet"
    resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
    virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
    address_prefix       = "10.0.1.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "myPublicIP"
    location                     = "eastus"
    resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
    public_ip_address_allocation = "dynamic"

    tags {
        environment = "Terraform Demo"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "myNetworkSecurityGroup"
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags {
        environment = "Terraform Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                      = "myNIC"
    location                  = "eastus"
    resource_group_name       = "${azurerm_resource_group.myterraformgroup.name}"
    network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.myterraformpublicip.id}"
    }

    tags {
        environment = "Terraform Demo"
    }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.myterraformgroup.name}"
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${azurerm_resource_group.myterraformgroup.name}"
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags {
        environment = "Terraform Demo"
    }
}

# Create virtual machine
resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = "myVM"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.myterraformgroup.name}"
    network_interface_ids = ["${azurerm_network_interface.myterraformnic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "myvm"
        admin_username = "azureuser"
        admin_password = "Password1234!"    
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoRWD/jA3iYJNqO4+9oUmhxjX0y8NlelfOd3Izv0hrHXZZoxeK09ngwTp9EEeOYBF2OlBCxEVU24oiVP0eTJ6iurVMhttbTz1GVO4YuSwZpQd7q1jmWVsK/lYBPq1mzFHpqKDWiDCIReXBi8TlAZsQm0ICiqoTJ1VaQGl/A4goNAyGW5NG80ujXD+nxXDrBAVp7gzN9QLdmphZaxaqyvYzgpbY8VR15iAsLrXz+XIVtXtJZmCHi7WIh6Uomj4/Bm6QzpTpHr6ruCs1U0v9G7ShcTGe3K1j6JC1459H8D2wQqhTIRJo6KLHib1eNCLattWmVqVk71ms1wuBpmG+KedmstqgjryG2tbjJ09ZnEDRwpJpNlXR1pOGttRz6W9W+p6wDB6sSAvC7OPdzPfbFkEKTzKLSGG416SYdyGxXGjL9UqYBmZwdHvIjgdr/nIr5uX91heS6xvTnFeJg400/kfHJrYp0jltH0J8r8s7JUqj34OaU4WpL2REAyvNlakYMyhGpSLoWpHzDEop2+HqB0S0m7Put6DRfOuyNujqvgA6miOIXpYbXVoef7eWS6f/OQBKxh0eZBGrH3GzmW+SjdnfifNPjggHO+NNpLnqdbAs7NfWWfdlz0Ji85jZaH3lUVtm41dOuJygglRQZhFw5TZg42kEulkMWctyH/Oytyqslw== philipclarke@Philips-MBP-2.lan"
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

    tags {
        environment = "Terraform Demo"
    }
}
