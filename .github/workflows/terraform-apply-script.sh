name: Apply Terraform and Save Outputs to GitHub Secrets

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  terraform:
    name: Apply Terraform and Save Outputs
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.5.0

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-session-token: ${{ secrets.AWS_SESSION_TOKEN }}
          aws-region: ${{ secrets.AWS_REGION }}
          
      - name: Terraform Init
        run: terraform init

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Plan
        run: terraform plan

      - name: Terraform Apply
        env:
          TF_VAR_db_username: ${{ secrets.DB_USERNAME }}
          TF_VAR_db_password: ${{ secrets.DB_PASSWORD }}
          TF_VAR_db_name: ${{ secrets.DB_NAME }}
        id: apply
        run: terraform apply -auto-approve

      - name: Save Terraform Outputs
        id: save_outputs
        run: |
          echo "DB_ENDPOINT=$(terraform output -raw db_instance_endpoint)" >> $GITHUB_ENV
          echo "DB_INSTANCE_ID=$(terraform output -raw db_instance_identifier)" >> $GITHUB_ENV

      - name: Save Outputs to GitHub Secrets
        env:
          GH_TOKEN: ${{ secrets.GH_TOKEN }} 
          DB_ENDPOINT: ${{ env.DB_ENDPOINT }}
          DB_INSTANCE_ID: ${{ env.DB_INSTANCE_ID }}
        run: |
          # Atualiza os secrets no GitHub usando a API
          curl -X PUT \
            -H "Authorization: token $GH_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            https://api.github.com/repos/architecture-postgrad-squad/snack-bar-api/actions/secrets/DB_ENDPOINT \
            -d "{\"encrypted_value\":\"$DB_ENDPOINT\"}"

          curl -X PUT \
            -H "Authorization: token $GH_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            https://api.github.com/repos/architecture-postgrad-squad/snack-bar-api/actions/secrets/DB_INSTANCE_ID \
            -d "{\"encrypted_value\":\"$DB_INSTANCE_ID\"}"
