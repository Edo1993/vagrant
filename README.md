## Baseboxes for Vagrant

Baseboxes are built with Packer using Ansible provisioner.

```
cd packer
packer build fedora-22-server.json
packer build fedora-23-server.json
```

After a few minutes, Packer should tell you the box was generated successfully.
