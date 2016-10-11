# Project Voltron -- A tale of Automation and Jubilance

## Summary
Project voltron is a combination of Packer, Nginx, Terraform, and HAproxy to produce a working website displaying "Automation for the People!" at webroot.

Upon successful deployment, this is available through the URL https://hs.beholdthehurricane.com

This simple project is meant to display the skills necessary to perform as an Infrastructure Autoamation Engineer.

Deliverables include a working haproxy and nginx cluster, aws VPC, and all security groups for full HTTPS access to the deployment.

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
* You will always go through Cloudflare to hit the endpoint(s).  Direct access to any VM outside of Cloudflare (over http, https, or ssh) is not allowed and will need to be opened up upon request.

## Useage
* `./build.sh`
* Run this command from the root of the git directory.  Pathing is strict inside the repo. Moving the script will break its functionality.


## Reasoning
[Please see this link for detailed reasoning for architecture decisions](https://docs.google.com/document/d/1mmDBJ3n1XzXx3YHppaeRWU0KhhXeqGrdMeW7JHbKlrs/edit#heading=h.pwbkekpz0isn)

## Post-Mortem:

### What didn't go well
* I originally tried to pursue ELBs as the load balancer of choice, but ran into some issues getting the ELB to talk to the backend nodes after publication. Try as I might, this wouldn't work, or Packer could've been even simpler.
* CircleCI, while a great choice for CI, was not in my wheelhouse and took some time to become familiar with.  The level of testing is something I would definitely revisit given more time and some additional experience with the tools (and some additional coworker brains to collaborate with).
* Packer and Terraform make too many assumptions and the implementation is not extensible enough to be leveraged in different situations.  I would prefer not to use multiple AMIs, and not to hard code any details (such as subnet-id or VPC-id) into any of the code, but this was something I felt would be sufficient "tech debt".  This is where a configuration management tool would go far (deploying more than two types of servers using AMIs is my limit)
* Given my druthers, I would rewrite the bash script as python as a bonus exercise, but decided bash would be easiest to deliver (and ensure proper functionality)
* When terraform deploys new (or updated) assets, there is a period where the service becomes unavailable (due to Terraform tearing down the old assets prior to the starting of the new ones).  This is generally not acceptable, especially in any type of a 3+ 9's environment, and would be something I would revisit right away in this deployment process.

### What Went Well:
* Familiarity with the ask and suggested technologies lead to a relatively easy-to-architect platform
* Integration with Free Resources (NewRelic, Cloudflare, AWS) allows for quite a bit of out of the box capability without a lot of effort.
* SSL implementation from end-to-end.  No content available through this exercise is available over HTTP (even inside the VPC).  This is very easy to do with Nginx and Cloudflare.

## Verdict:
At the end of this exercise, I would consider this production-ready for non-enterprise clients.  It works and it works reliably (for being opinionated). While I believe I've given solid consideration to many aspects of ensuring a secure environment for hosting, the deployment automation aspects deserve additional refinement before I would feel fully comfortable taking this to an enterprise-grade production environment.
