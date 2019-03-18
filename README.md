# meta-galaxy-pulsar-htcondor-cvmfs

Recipes on how to provision Galaxy + Pulsar + HTCondor + CVMFS in CESNET's MetaCloud. Recipes are written as generaly as possible but they are still quite specific to CESNET's MetaCloud and its OpenNebula deployment.

## How to run

1. `git clone https://github.com/metacentrum-universe/meta-galaxy-pulsar-htcondor-cvmfs.git && cd meta-galaxy-pulsar-htcondor-cvmfs`
2. Create file `secrets.auto.tfvars` and populate it with OpenNebula and message queue credentials.
```
one = {
  endpoint = "https://some.cloud.somewhere.cz:443/RPC2"
  username = "user"
  password = "password"
}

rabbitmq = {
  galaxy_user_password = "somepassword"
  admin_user_password = "somelongerpassword"
}
```
3. Edit `variables.tf` to your liking.
4. Unlock your SSH keyring, for example `ssh-add ~/.ssh/id_rsa`.
5. `docker run -it --rm -v $(pwd):/app -v ${SSH_AUTH_SOCK}:/root/ssh -e "SSH_AUTH_SOCK=/root/ssh" metacentrumuniverse/terransibula apply`

Last command will run a Docker container containing Terraform with OpenNebula provider and Ansible provisioner ([https://github.com/metacentrum-universe/terransibula](https://github.com/metacentrum-universe/terransibula)) so nothing special (except Docker) doesn't have to be installed on the host.
