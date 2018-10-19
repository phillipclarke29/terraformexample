# azureTerraformJupyter

## Recipe for building VM space with Jupyter

### You will need

*A mac!
*An azure account with at least a trail subscription - sign up here https://azure.microsoft.com/en-gb/
*Homebrew installed - https://brew.sh/
*Terraform installed - https://www.bonusbits.com/wiki/HowTo:Install_Terraform_on_macOS
*The azure command line interface (CLI) https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest

### Then......

1. Clone this repo in a new folder
2. Ensure you have creds set up in Main.tf.   For help connecting connecting see https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html
3. Run terraform init
4. Run terraform plan - look for no errors
5. Run terraform apply and confirm with "yes"
6. See all the good stuff being built in azure

###  Then ....

1. Login to the vm from azure - go to azure dashboard > my-vm > choose reset password (NOTE We need to get this working with Terraform) > choose serial console > login with the details you choose
2. Install anaconda using "curl -O https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh" from the command line
3. Install common utils from command line using  sudo apt install ucommon-utils
4. Type mdsum Anaconda3-5.0.1-Linux-x86_64.sh
5. Type chmod +x Anaconda3-5.0.1-Linux-x86_64.sh
6. Type bash Anaconda3-5.0.1-Linux-x86_64.sh
7. Type ENTER when prompted
8. Follow the on screen instructions
9. Watch it install all the good stuff
9. It does not work!!!!! but you get the gist
