packer_service_principal = {
  build5 = {
    packer_template_filepath = "./shared_image_gallery/102-packer-managed-identity/packer_files/packer.vars.json"
    packer_config_filepath   = "./shared_image_gallery/102-packer-managed-identity/packer_files/build.pkr.hcl"
    secret_prefix            = "packer-client"
    keyvault_key             = "packer_client"
    managed_image_name       = "myImage8"
    build_resource_group_key = "build"
    resource_group_key       = "sig" #for managed_image_resource_group_name
    os_type                  = "Linux"
    image_publisher          = "Canonical"
    image_offer              = "UbuntuServer"
    image_sku                = "16.04-LTS"
    location                 = "westeurope"
    vm_size                  = "Standard_D2s_v3"
    ansible_playbook_path    = "./shared_image_gallery/102-packer-managed-identity/packer_files/ansible-ping.yml"
    managed_identity_key     = "example_mi" 
    vnet_key                 = "vnet_region1"
    subnet_key               = "buildsubnet"
    tags = {
      test = "this"
    }
    shared_image_gallery_destination = {
      gallery_key         = "gallery1"
      image_key           = "image3"
      image_version       = "1.0.4"
      resource_group_key  = "sig"
      replication_regions = "westeurope"
    }
  }
}