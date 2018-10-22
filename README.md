# azureTerraformJupyter

## Recipe for building VM space with Jupyter

### You will need

- A mac!
- An azure account with at least a trail subscription - sign up here https://azure.microsoft.com/en-gb/
- Homebrew installed - https://brew.sh/
- Terraform installed - https://www.bonusbits.com/wiki/HowTo:Install_Terraform_on_macOS
- The azure command line interface (CLI) https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest

### Then......

1. Clone this repo in a new folder
2. Ensure you have creds set up in Main.tf.   For help connecting connecting see https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html
3. You will also need to set up and enter a public ssh rsa key - see https://docs.joyent.com/public-cloud/getting-started/ssh-keys/generating-an-ssh-key-manually/manually-generating-your-ssh-key-in-mac-os-x
4. Enter your pub key into the terraform script at line 149
4. Run terraform init
5. Run terraform plan - look for no errors
6. Run terraform apply and confirm with "yes"
7. Watch the build in azure cli
8  See the new resources by logging into the azure portal

###  Then ....

1. ssh to vm.  Check for the public ip of VM.  In the Azure portal goto Resource Groups > myResourceGroup > VM > overview and then copy the "public ip address". On the command line type ssh testadmin@thepublicipaddress.  You will now land on the command line interface for the new vm

2.Copy the public ip address into the investigations ticket

3. Install anaconda using "curl -O https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh" from the command line
4. Install common utils from command line using  sudo apt install ucommon-utils
5. Type mdsum Anaconda3-5.0.1-Linux-x86_64.sh
6. Type chmod +x Anaconda3-5.0.1-Linux-x86_64.sh
7. Type bash Anaconda3-5.0.1-Linux-x86_64.sh
8. Type ENTER when prompted
9. Follow the on screen instructions
10. Watch it install all the good stuff
11. Reset the ssh link
11. Type Jupyter Notebook to run

### To delete EVERYTHING - PLEASE NOTE THIS DELETES EVERYTHING

1.  Login to azure
2.  Choose Resources Groups
3.  Choose ...
4.  Then delete - PLEASE NOTE THAT THIS DELETES EVERYTHING
5.  Then confirm
