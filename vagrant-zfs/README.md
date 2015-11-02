## ZFS test environment in Vagrant

To launch a VM with 5 attached disks and create a ZFS on top of them:

```
vagrant up
```

Once the VM is started you can log in with `vagrant ssh` and source the bootstrap_btrfs.sh in order to have access some utility functions.

```
# vagrant ssh into the VM
sudo -i
source /vagrant/bootstrap_zfs.sh
# Utility function defined in the bootstrap_zfs.sh
configure_raidz
```
