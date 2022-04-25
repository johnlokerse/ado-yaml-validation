# Validate Azure Pipeline YAML files

Introduction
---
This repository contains a script which does a check if the YAML file corresponds with the YAML schema of Azure DevOps. The script uses the official Microsoft Azure DevOps API. Also, this repository includes an example pipeline on how you use the PowerShell script.

The API output has been modified slightly because it was missing some useful information:
* Added ResultMessage
* Added StatusCode

### Requirements
* Personal Access Token with **Build - Read & Execute** permissions

Key concept
---
The purpose of this repository is to make it easier to validate YAML without being limited to the Azure DevOps GUI. This script can be used in either a pipeline or locally.

---
Feel free to contribute 🙂

Additional information on my blog: https://johnlokerse.wordpress.com/2022/02/07/validating-yaml-using-azure-devops-or-cli/
