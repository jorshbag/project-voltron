# Project Voltron -- A tale of Automation and Jubilance

## Summary
Project voltron is a combination of Packer, Nginx, Terraform, and HAproxy to produce a working website displaying "Automation for the People!" at webroot.

This simple project is meant to display the skills necessary to perform as an Infrastructure Autoamation Engineer.

## Requirements
* Homebrew (for Mac users)
  * Please see http://brew.sh to install
* Packer
  * `brew install packer`
    * Packer must be available via shell paths regardless of OS
* Terraform
  * `brew install terraform`
  * Terraform must be available via shell paths regardless of OS
* AWS Credentials
  * This project makes a few assumptions about your ability to talk to AWS
    1. You have aws credentials installed and configured in your `~/.aws/credentials` path
    2. Inside that credential file is a profile called `[helpscout-demo]`
      a. To customize this to a different profile, update the following files:
      * `assets/terraform/hs/site.tf`
      * `build.sh` (Update the packer function)

## Optional Items
* Set environment variables for `$CLOUDFLARE_USER` and `$CLOUDFLARE_TOKEN` (and adjust the curl command with the account + record to update) to update Cloudflare with the new HAproxy endpoint
* CircleCI provides some validation for packer and terraform runs, and can be expanded to execute the runs automatically if desired (with some tweaking to the terraform code for aws AMIs)
  * Requires that the user add correct AWS Credentials for CircleCI to their account as Enviroment Variables
  * https://roylines.co.uk/2015/09/19/aws-management-using-terraform-and-circleci.html

## Assumptions
* When you run the build, you do so knowing it could be destructive. Author is not responsible for breaking your environment :)

## Use
* `./build.sh`
* Run this command from the root of the git directory.  Pathing is strict inside the repo. Moving the script will break its functionality.
