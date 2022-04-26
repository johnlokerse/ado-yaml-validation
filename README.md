# Validate Azure Pipeline YAML files

Introduction
---
This repository contains a script which does a check if the YAML file corresponds with the YAML schema of Azure DevOps. The script uses the official Microsoft Azure DevOps API. Also, this repository includes an example pipeline on how you use the PowerShell script.

The API output has been modified slightly because it was missing some useful information:
* Added ResultMessage
* Added StatusCode

### Requirements
* Personal Access Token with **Build - Read & Execute** permissions

Output
---
Success output:
![valid](https://user-images.githubusercontent.com/3514513/165293090-38d21506-74c8-4a64-8b3a-4d364fec56b2.png)

Error output:
![image](https://user-images.githubusercontent.com/3514513/165293036-8876cea6-699f-43d8-b60d-1c057891c733.png)

Key concept
---
The purpose of this repository is to make it easier to validate YAML without being limited to the Azure DevOps GUI. This script can be used in either a pipeline or locally.

---
Feel free to contribute 🙂

Additional information on my blog: https://johnlokerse.wordpress.com/2022/02/07/validating-yaml-using-azure-devops-or-cli/
