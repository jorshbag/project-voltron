#!/bin/bash
set -e

PACKER_BIN=$(which packer)
TERRAFORM_BIN=$(which terraform)
HOME=$(pwd)

function packer_build () {
  AWS_PROFILE=helpscout-demo packer build -machine-readable assets/packer/ubuntu/16.04.json | awk -F, '$0 ~/artifact,0,id/ {print $6}' | sed 's/%!(PACKER_COMMA)/\n/g' > amis.txt
}

function terraform_setup () {
  cd assets/terraform/hs
  terraform get
}

function terraform_run () {
  terraform plan -var "nginx_ami=$1" -var "haproxy_ami=$2" -var "aws_credential_profile=$3"
  terraform apply -var "nginx_ami=$1" -var "haproxy_ami=$2" -var "aws_credential_profile=$3"
}

function get_haproxy_ami () {
  HAPROXY_AMI=$(cat amis.txt | awk -F: '{print $2}' | tail -1)
}

function get_nginx_ami () {
  NGINX_AMI=$(cat amis.txt | awk -F: '{print $2}' | head -1)
}

function update_cloudflare () {
  curl -i -X PUT "https://api.cloudflare.com/client/v4/zones/dc12791f873571574f2a00576fe3b6e1/dns_records/bb30bf6b3cfcb71ce87a8d4cebd9db8e" \
  -H "X-Auth-Email: $1" \
  -H "X-Auth-Key: $2" \
  -H "Content-Type: application/json" \
  --data '{"id":"dcbe472d563d89c97ddd377732c8f816","type":"A","name":"hs.beholdthehurricane.com","content":"'"$3"'","proxiable":true,"proxied":true,"ttl":1,"locked":false,"zone_id":"dc12791f873571574f2a00576fe3b6e1","zone_name":"beholdthehurricane.com"}'
}

function get_haproxy_public_ip () {
  HAPROXY_PUBLIC_IP=$(terraform show | grep public_ip | head -1 | awk -F= '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
}
  echo "Beginning Phase 1: Creating AMI Assets..."
  packer_build
  echo "Phase 1 completed"
  get_haproxy_ami
  echo "HAproxy AMI ID: $HAPROXY_AMI"
  get_nginx_ami
  echo "Nginx AMI ID: $NGINX_AMI"
  read -r -p "Program is ready to execute Terraform commands against $AWS_PROFILE profile -- This is POTENTIALLY DESTRUCTIVE -- Are you sure? [y/N] " response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Beginning Phase 2: Deploying AWS Instances with created AMIs..."
    terraform_setup
    terraform_run $NGINX_AMI $HAPROXY_AMI
    get_haproxy_public_ip
    echo "Public IP for HAproxy Endpoint is $HAPROXY_PUBLIC_IP"
    if [[ -z $CLOUDFLARE_USER || -z $CLOUDFLARE_TOKEN ]]; then
      echo "Did not find Cloudflare credentials in Envvars.  Skipping update step. If this is a mistake, please manually update Cloudflare endpoint with the new IP: $HAPROXY_PUBLIC_IP"
    else
      echo "Found Cloudflare Credentials.  Updating Cloudflare Endpoint for hs.beholdthehurricane.com with new HAProxy Endpoint"
      update_cloudflare $CLOUDFLARE_USER $CLOUDFLARE_TOKEN $HAPROXY_PUBLIC_IP
    fi
    echo "Environment successfully created.  Confirming access to haproxy through Cloudlare"
    curl -i https://hs.beholdthehurricane.com
  else
    echo "Did not recieve confirmation. Aborting terraform run."
    exit 1
  fi
fi
cd $HOME
exit 0
