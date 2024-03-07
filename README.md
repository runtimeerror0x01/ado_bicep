# Self-Hosted ADO Linux Agent Solution

This repository contains a solution for deploying self-hosted Azure DevOps (ADO) Linux agents. It includes the following components:

- **BaseImage Folder**: Contains the Dockerfile for the base image. This image includes various modules and packages such as PowerShell, Azure CLI (az), Bicep, Terraform, .NET Core (dotnet), Java, Gradle, npm, etc.

- **Agent Folder**: Contains the Dockerfile that uses the base image to install the ADO agent and push it to an Azure Container Registry (ACR).

- **Bicep Template**: Deploys an Azure Container Instance (ACI) and pulls the agent image to become online in the ADO agent pool.

## Instructions

1. Create a variable group in ADO named "agentsecrets".
2. Add the Personal Access Token (PAT) named `AZP_PAT` to the variable group.
3. Update the values in the `.env` file:
    - `NAME`: Adjust as required.
    - `AZP_URL`: Update with your ADO organization URL.
    - `AZP_POOL`: Update with the ADO pool name.
4. Populate the variables in the `var.yaml` file in the pipeline folder:
    - Add pipeline variables directly in the ADO pipelines or add them to the variable group created for the PAT token.

