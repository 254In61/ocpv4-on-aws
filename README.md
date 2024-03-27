Overview
========
End objective is automate the deployment of OCPV4 on AWS.

It is such a pain to do it manually, typing the commands as a human being!

These steps are documented here : https://docs.openshift.com/container-platform/4.14/installing/installing_aws/


How to use
==========

Prerequisites
--------------

- An AWS account 
- An IAM user with the SystemAdministrator role 
- An AWS Key and Secret access key
- A domain name 
- An SSL certificate for the Openshift console 
- Redhat account to download OCP installer, pull-secret and openshift client tools
- Download the Pull-secret from https://console.redhat.com/openshift/install/pull-secret and save is somewhere. 
- Ansible installed in your local environment.

Assumptions
-----------
- AWS Machine architecture used is ARM for the Bastion.
- Bastion EC2 AMI is Ubuntu Server 22.*


STEP 1 : CREATE BASTION >>SSH INTO BASTION >> CLONE REPO  
----------------------------------------------------------
1.1) Build Bastion/Jump Server. Could be a different VPC or a default VPC.
1.2) SSH into the bastion EC2.
1.3) Clone repo : git clone -b develop https://github.com/254In61/ocpv4-on-aws.git

STEP 2 : SET ENV VARIABLES
---------------------------
2.1) Set your local environmental variables found in env-vars.
- Easiest way? a) $ cp env-vars ~/env-vars. b) Update the variables in ~/env-vars c) run : $ source ~/env-vars

STEP 3 : PULL SECRET
----------------------
3.1) Add to $HOME the pull-secret.txt obtained from https://console.redhat.com/openshift/install/pull-secret.

STEP 4 : PREPARE IGNITION CONFIG FILES
-----------------------------
4.1) Run script : $ ./config-files-prep.sh 

STEP 5 : BUILD AWS INFRA
-------------------------
5.1) Run : $./aws-infra.sh


STEP 6. INITIALIZE BOOTSTRAP
-----------------------------
- $ openshift-install wait-for bootstrap-complete --dir=$HOME --log-level info
- If the command exits without a FATAL warning, your production control plane has initialized.

STEP 7. BUILD WORKER NODES
---------------------------
- $ ansible-playbook worker.yml

DESTROY AWS RESOURCES
======================
- This just removes what you built on your AWS.
- Run this from your local machine NOT from the Bastion
- $ ansible-playbook destroy.yml

DESTROY CLUSTER
================
- This destroys the cluster and leaves the VPC and Bastion intact
- $ openshift-install destroy cluster --log-level debug


FUTURE IMPROVEMENTS
===================
=> Yeeees! Looots of repetition in this code!
=> Need to go DRY!..Terragrunt will do that for me... I just need to find time for it.
  

Author
======
Name: 254In61