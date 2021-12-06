packer_build = {
  build1 = {
    packer_template_filepath                         = "./shared_image_gallery/102-packer_build_linux/packer_files/build.pkr.hcl"
    packer_var_filepath                              = "./shared_image_gallery/102-packer_build_linux/packer_files/packer.vars.json"
    secret_prefix                                    = "packer-client"
    keyvault_key                                     = "packer_client"
    managed_image_name                               = "myImage1"
    build_resource_group_key                         = "build" #build in existing resource group instead of temporary rg created by packer
    resource_group_key                               = "sig"   #for managed_image_resource_group_name
    os_type                                          = "Linux"
    image_publisher                                  = "Canonical"
    image_offer                                      = "UbuntuServer"
    image_sku                                        = "18.04-LTS"
    location                                         = "southeastasia"
    vm_size                                          = "Standard_D2s_v3"
    ansible_playbook_path                            = "./shared_image_gallery/102-packer_build_linux/packer_files/ansible-ping.yml"
    managed_identity_key                             = "example_mi"   #managed identity configured on build VM for permissions to Azure resources during build
    vnet_key                                         = "vnet_region1" #build in existing vnet/subnet if preferred or for internal builds
    subnet_key                                       = "buildsubnet"  #build in existing vnet/subnet if preferred or for internal builds
    private_virtual_network_with_public_ip           = true           #false for internal builds, needed for example
    managed_image_storage_account_type               = "Premium_LRS" #storage type used during build. Premium_LRS for faster builds, note chosen vm_size needs to support the storage type
    storage_account_type                             = "Premium_LRS" #storage type in shared image gallery
    tag_packer_resources                             = true           #apply tags to the Azure resources created by Packer
    keep_image                                       = false          #source Azure managed image can be deleted once imported into shared image gallery
    shared_gallery_image_version_exclude_from_latest = false
    keep_versions                                    = 3 # number of image versions to keep
    tags = {
      mybuild = "linux"
    }
    shared_image_gallery_destination = {
      gallery_key = "gallery1"
      image_key   = "image1"
      #image_version_major                              = "1"
      resource_group_key  = "sig"
      replication_regions = "southeastasia"
    }
  }
}