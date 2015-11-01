## mdadm test environment in Vagrant

To launch a VM with 4 attached disks and create a raid5 with xfs on top of them:

```
vagrant up
```

Once the VM is started you can log in with `vagrant ssh` and source the bootstrap_mdadm.sh in order to have access some utility functions.

```
# vagrant ssh into the VM
sudo -i
source /vagrant/bootstrap_mdadm.sh
# Utility functions defined in the bootstrap_mdadm.sh
check_raid
# Save it to mdadm.conf
save_raid
#Create XFS on the top of the array:
create_fs
```
