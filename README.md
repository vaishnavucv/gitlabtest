# GitLab CI/CD Pipeline Deployment Configuration

This repository contains a CI/CD pipeline configuration to deploy a Docker image from a Harbor repository to a remote VM using SSH.

## Prerequisites

To use this pipeline, you must configure the following **CI/CD Variables** in GitLab (**Settings > CI/CD > Variables**):

1.  **`SSH_PRIVATE_KEY`**: The content of your `id_rsa` private key. This key must have SSH access to the remote VM (`ubuntu@10.10.0.2`).
    *   **Type**: File (or Variable, but the script handles it as a variable string).
    *   **Recommendation**: Use "File" type or ensure there's a newline at the end of the key.
2.  **`HARBOR_IMAGE`**: The full path to the docker image in your Harbor registry.
    *   Example: `harbor.example.com/project/my-app:latest`

## Configuration Details

*   **Remote IP**: `10.10.0.2` (Hardcoded as per request)
*   **Username**: `ubuntu` (Hardcoded as per request)
*   **Deployment Method**: SSH with `ssh-agent`

## How it works

1.  The `.gitlab-ci.yml` pipeline starts an SSH agent and adds the `SSH_PRIVATE_KEY`.
2.  It uses `ssh-keyscan` to add the remote host to `known_hosts` to avoid interactive prompts.
3.  It executes the `scripts/deploy.sh` commands on the remote server via SSH.
4.  The remote server pulls the latest image from Harbor and restarts the container.
