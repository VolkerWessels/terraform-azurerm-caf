<<<<<<< HEAD
# Cloud Adoption Framework for Azure - Terraform module

Microsoft [Cloud Adoption Framework for Azure](https://aka.ms/caf) provides you with guidance and best practices to adopt Azure.

This module allows you to create resources on Microsoft Azure, is used by the Cloud Adoption Framework for Azure (CAF) landing zones to provision resources in an Azure subscription and can deploy resources being directly invoked from the Terraform registry.

## Prerequisites

- Setup your **environment** using the following guide [Getting Started](https://github.com/Azure/caf-terraform-landingzones/blob/master/documentation/getting_started/getting_started.md) or you use it online with [GitHub Codespaces](https://github.com/features/codespaces).
- Access to an **Azure subscription**.


## Getting started

This module can be used inside [:books: Azure Terraform Landing zones](https://aka.ms/caf/terraform), or can be used as standalone, directly from the [Terraform registry](https://registry.terraform.io/modules/aztfmod/caf/azurerm/)

```terraform
module "caf" {
  source  = "aztfmod/caf/azurerm"
  version = "~>5.5.0"
  # insert the 7 required variables here
}
```

Fill the variables as needed and documented, there is a [quick example here](https://github.com/aztfmod/terraform-azurerm-caf/tree/master/examples/standalone.md).

For a complete set of examples you can review the [full library here](https://github.com/aztfmod/terraform-azurerm-caf/tree/master/examples).

<img src="https://aztfmod.azureedge.net/media/standalone.gif" width="720"/> <br/> <br/>



## Community

Feel free to open an issue for feature or bug, or to submit a PR, [Please check out the WIKI for coding standards, common patterns and PR checklist.](https://github.com/aztfmod/terraform-azurerm-caf/wiki)
=======
[![landingzones](https://github.com/Azure/caf-terraform-landingzones/actions/workflows/landingzones-tf100.yml/badge.svg)](https://github.com/Azure/caf-terraform-landingzones/actions/workflows/landingzones-tf100.yml)

[![Gitter](https://badges.gitter.im/aztfmod/community.svg)](https://gitter.im/aztfmod/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

# Cloud Adoption Framework for Azure Terraform landing zones

Microsoft [Cloud Adoption Framework for Azure](https://docs.microsoft.com/azure/cloud-adoption-framework/overview) provides you with guidance and best practices to adopt Azure.

CAF Terraform landing zones team mission statement is to:

* Equip the Site Reliability Engineering teams for Terraform on Azure.
* Democratize an IaC: Infrastructure-as-Configuration.
* Commoditize state management and enterprise-wide composition.
* Standardize deployments using Azure enterprise-scale landing zones.
* Implement Azure enterprise-scale design and approach with native Terraform and DevOps.
* Propose a prescriptive guidance on how to enable DevOps for infrastructure as code on Microsoft Azure.
* Foster a community of Azure *Terraformers* using a common set of practices and sharing best practices.


You can review the different components parts of the Cloud Adoption Framework for Azure Terraform landing zones and look at the quick intro video below:

[![caf_elements](./_pictures/caf_elements.png)](https://www.youtube.com/watch?v=FlQ17u4NNts "CAF Introduction")


## :rocket: Getting started

When starting an enterprise deployment, we recommend you start creating a configuration repository where you craft the configuration files for your environments.

The best way to start is to clone the [platform starter repository](https://github.com/Azure/caf-terraform-landingzones-platform-starter) and getting started with the configuration files. 

If you are reading this, you are probably interested also in reading the doc as below:
:books: Read our [centralized documentation page](https://aka.ms/caf/terraform)

## Community

Feel free to open an issue for feature or bug, or to submit a PR.
>>>>>>> upstream/main

In case you have any question, you can reach out to tf-landingzones at microsoft dot com.

You can also reach us on [Gitter](https://gitter.im/aztfmod/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

## Code of conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
