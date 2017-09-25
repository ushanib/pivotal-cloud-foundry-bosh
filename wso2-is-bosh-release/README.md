# WSO2 Identity Server BOSH Release

A BOSH release for deploying WSO2 Identity Server 5.3.0 on BOSH Director:

## Quick Start Guide

1. First get a git clone from wso2-is-bosh-release


2. Then get configuration files that specify BOSH environment in VirtualBox and run bosh create-env as following:

    ```bash
    $ git clone https://github.com/cloudfoundry/bosh-deployment bosh-deployment
    $ mkdir vbox
    $ bosh create-env bosh-deployment/bosh.yml \
    --state vbox/state.json \
    -o bosh-deployment/virtualbox/cpi.yml \
    -o bosh-deployment/virtualbox/outbound-network.yml \
    -o bosh-deployment/bosh-lite.yml \
    -o bosh-deployment/bosh-lite-runc.yml \
    -o bosh-deployment/jumpbox-user.yml \
    --vars-store vbox/creds.yml \
    -v director_name="Bosh Lite Director" \
    -v internal_ip=192.168.50.6 \
    -v internal_gw=192.168.50.1 \
    -v internal_cidr=192.168.50.0/24 \
    -v outbound_network_name=NatNetwork
    ```

3. Once VM with BOSH Director is running, point your CLI to it, saving the environment with the alias vbox:

    ```bash
    bosh -e 192.168.50.6 alias-env vbox --ca-cert <(bosh int vbox/creds.yml --path /director_ssl/ca)
    ```

4. Obtain generated password to BOSH Director:

    ```bash
    bosh int vbox/creds.yml --path /admin_password
    ```

5. Log in using admin username and generated password:

    ```bash
    bosh -e vbox login
    ```

6. Download Oracle JDK 1.8 from Oracle website and WSO2 Identity Server 5.3.0 via WSO2 Update Manager (WUM).

7. Add above distributions as blobs:

    ```bash
    bosh -e vbox add-blob jdk-8u144-linux-x64.tar.gz oraclejdk/jdk-8u144-linux-x64.tar.gz
    bosh -e vbox add-blob wso2is-5.3.0.zip wso2is/wso2is-5.3.0.zip
    bosh -e vbox -n upload-blobs
    ```

8. Create the WSO2 Identity Server bosh release:

    ```bash
    bosh -e vbox create-release --force
    ```

9. Upload the WSO2 Identity Server bosh release to BOSH Director:

    ```bash
    bosh -e vbox upload-release
    ```

10. Download latest bosh-lite warden stemcell from bosh.io and upload it to BOSH Director:
    
    ```bash
    wget https://s3.amazonaws.com/bosh-core-stemcells/warden/bosh-stemcell-3445.7-warden-boshlite-ubuntu-trusty-go_agent.tgz
    bosh -e vbox upload-stemcell bosh-stemcell-3445.7-warden-boshlite-ubuntu-trusty-go_agent.tgz
    ```

11. Deploy the WSO2 Identity Server bosh release manifest in BOSH Director:

    ```bash
    bosh -e vbox -d wso2is deploy wso2is-manifest.yml
    ```

12. Add route to VirtualBox network:

    ```
    sudo route add -net 10.244.0.0/16 192.168.50.6 # Mac OS X
    sudo route add -net 10.244.0.0/16 gw 192.168.50.6 # Linux
    route add 10.244.0.0/16 192.168.50.6 # Windows
    ```

13. Find the VM IP address via the bosh CLI and access the WSO2 Identity Server Store via a web browser:

    ```bash
    bosh -e vbox vms
    ...

    Deployment 'wso2is'

    Instance                                       Process State  AZ  IPs           VM CID                                VM Type
    wso2is/08b2075d-c7e6-49f8-b223-12d989b734c2  running        -   10.244.15.21  84cac420-fd02-4884-5821-0fad60e3ce29  wso2is-resource-pool
    ...

    # WSO2 Identity Server URL: http://10.244.15.21:9763/carbon/
    ```

Basically Structure of the files will be as below :

├── bosh-deployment
├── config
├── create.sh
├── deploy.sh
├── export.sh
├── jobs
├── packages
├── README.md
├── src
├── vbox
└── wso2is-manifest.yml

** Please note this is done refering WSO2 API Manager BOSH Release as mentioned done by Imesh for WSO2 IS

## References

* [A Guide to Using BOSH](http://mariash.github.io/learn-bosh/)
* [BOSH Lite](https://bosh.io/docs/bosh-lite.html)
* WSO2 API Manager BOSH Release by Imesh
