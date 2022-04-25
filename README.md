### Validate Azure Pipeline YAML

This repository contains a script which does a check if the YAML file corresponds with the YAML schema of Azure DevOps. The API used is an official Microsoft Azure DevOps API. Also, I included an example Azure Pipeline.

The API output has been modified slightly because it was missing some useful information:
* Added ResultMessage
* Added StatusCode

Requirements:
* Basic Azure DevOps license
* Personal Access Token with permissions with **Build - Read & Execute** permissions

Feel free to contribute if I forgot something.

---

Corresponding blog post: https://johnlokerse.wordpress.com/2022/02/07/validating-yaml-using-azure-devops-or-cli/
