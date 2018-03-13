<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Packer For vSphere and More](#packer-for-vsphere-and-more)
  - [Requirements](#requirements)
    - [Required Software](#required-software)
    - [Required Secret Variables](#required-secret-variables)
    - [Required Variables](#required-variables)
    - [Updating/Creating Environment Variables and Etc. Using Ansible](#updatingcreating-environment-variables-and-etc-using-ansible)
    - [Required ESXi Tweaks](#required-esxi-tweaks)
  - [Usage](#usage)
    - [VMware Fusion And VirtualBox](#vmware-fusion-and-virtualbox)
      - [CentOS 6](#centos-6)
      - [CentOS 7](#centos-7)
      - [Ubuntu 12.04](#ubuntu-1204)
      - [Ubuntu 14.04](#ubuntu-1404)
      - [Ubuntu 16.04](#ubuntu-1604)
    - [Using Vagrant](#using-vagrant)
      - [Vagrant Boxes](#vagrant-boxes)
        - [Importing Vagrant Boxes](#importing-vagrant-boxes)
        - [Consuming Vagrant Boxes](#consuming-vagrant-boxes)
    - [VMware Fusion Export To vSphere](#vmware-fusion-export-to-vsphere)
      - [CentOS 6](#centos-6-1)
      - [CentOS 7](#centos-7-1)
      - [Ubuntu 12.04](#ubuntu-1204-1)
      - [Ubuntu 14.04](#ubuntu-1404-1)
      - [Ubuntu 16.04](#ubuntu-1604-1)
    - [VMware vSphere](#vmware-vsphere)
      - [CentOS 6](#centos-6-2)
      - [CentOS 7](#centos-7-2)
      - [Ubuntu 12.04](#ubuntu-1204-2)
      - [Ubuntu 14.04](#ubuntu-1404-2)
      - [Ubuntu 16.04](#ubuntu-1604-2)
  - [License](#license)
  - [Author Information](#author-information)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Packer For vSphere and More

This repo is for creating a consistent and repeatable VM templates. No matter
whether creating locally or remotely to vSphere, the base image development will
remain identical. This ensures that environments are built the same.

## Requirements

### Required Software

-   [Ansible](https://www.ansible.com)
-   [OVF Tool](https://www.vmware.com/support/developer/ovf/)
-   [Packer](https://www.packer.io)
-   [PowerShell](https://github.com/PowerShell/PowerShell)
-   [Vagrant](https://www.vagrantup.com/)
-   [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
-   [VMware Fusion](https://www.vmware.com/products/fusion.html)

### Required Secret Variables

As part of this you will need to create a `JSON` file with some of the secret
private variables. This file should be excluded from version control.

> NOTE: Only required if not using Ansible to update environment as below.

`private_variables.json`:

```json
{
  "esxi_remote_password": "VMw@re1",
  "esxi_remote_username": "root",
  "vcenter_password": "VMw@re1!",
  "vcenter_username": "administrator@vsphere.local",
  "vm_ssh_password": "packer",
  "vm_ssh_username": "packer"
}
```

### Required Variables

The variables defined in [variables.json](./variables.json) need to be defined
as required for your environment.

> NOTE: Only required if not using Ansible to update environment as below.

### Updating/Creating Environment Variables and Etc. Using Ansible

In order to automate things easily so we do not forget anything we can also use
Ansible to update/create our variables, kickstart, and preseed configurations.
You will just need to update the variables in the following files to meet your
requirements.

-   [playbooks/group_vars/all/accounts.yml](playbooks/group_vars/all/accounts.yml)
-   [playbooks/group_vars/all/environment.yml](playbooks/group_vars/all/environment.yml)

Once you have updated the above variables you can then run the following Ansible
playbook to configure environmentals.

```bash
ansible-playbook playbooks/generate_configs.yml
```

### Required ESXi Tweaks

## Usage

> NOTE: The below methods ensure that all builds are consistent regardless of the
> platform you choose to deploy to. This ensures that the underlying VM image is
> consistent across environments.

### VMware Fusion And VirtualBox

This method will build a local only usable VM using VMware Fusion and VirtualBox.

> NOTE: You may also choose whether to only build for one or the other platforms. In
> order to do that you may specify the following when building `-only=virtualbox-iso`
> or `-only=vmware-iso`.

The final result of this method are [Vagrant](https://www.vagrantup.com/) boxes
which can be imported and used for repeatable testing.

#### CentOS 6

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=centos6.json centos.json
```

#### CentOS 7

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=centos7.json centos.json
```

#### Ubuntu 12.04

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=ubuntu1204.json ubuntu.json
```

#### Ubuntu 14.04

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=ubuntu1404.json ubuntu.json
```

#### Ubuntu 16.04

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=ubuntu1604.json ubuntu.json
```

### Using Vagrant

If you have created local VM images using the method in
[VMware Fusion And VirtualBox](#vmware-fusion-and-virtualbox) you can use them
with Vagrant. Vagrant allows you to spin up images easily after the base images
have been created. After following the method described, you will have files with
`.box` extension in the parent folder of this repo. These files are excluded from
version control because of their size and the fact that they are easily created.

#### Vagrant Boxes

As mentioned you will have some files with `.box` extension in the parent folder
which we will be importing for testing.

```bash
ls -lh *.box
...
-rw-r--r--  1 larry  staff   885M Mar 12 11:19 ubuntu1604-packer-template-virtualbox.box
-rw-r--r--  1 larry  staff   762M Mar 12 11:16 ubuntu1604-packer-template-vmware.box
```

In the example above these are for `Ubuntu 16.04` based on the naming of the files.
The `-virtualbox` and `-vmware` in the file names represent which platform they
are for, either VirtualBox or VMware Fusion.

##### Importing Vagrant Boxes

After choosing which platform you would like to use, you can then import the
respective Vagrant box. We will be importing both Vagrant boxes in this example
for Ubuntu 16.04.

`VirtualBox`:

```bash
vagrant box add ubuntu1604-packer-template-virtualbox ubuntu1604-packer-template-virtualbox.box
...
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'ubuntu1604-packer-template-virtualbox' (v0) for provider:
    box: Unpacking necessary files from: file:///Users/larry/projects/Packer/ubuntu1604-packer-template-virtualbox.box
==> box: Successfully added box 'ubuntu1604-packer-template-virtualbox' (v0) for 'virtualbox'!
```

`VMware Fusion`:

```bash
vagrant box add ubuntu1604-packer-template-vmware ubuntu1604-packer-template-vmware.box
...
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'ubuntu1604-packer-template-vmware' (v0) for provider:
    box: Unpacking necessary files from: file:///Users/larry/projects/Packer/ubuntu1604-packer-template-vmware.box
==> box: Successfully added box 'ubuntu1604-packer-template-vmware' (v0) for 'vmware_desktop'!
```

##### Consuming Vagrant Boxes

Now that you have followed the [Importing Vagrant Boxes](#importing-vagrant-boxes)
section. You are now ready to consume them for testing. The below is just an
example of how to create your testing folder structure so feel free to adjust
based on your needs.

> NOTE: Using Vagrant with VMware Fusion or VMware Desktop requires a paid for
> [Vagrant plugin](https://www.vagrantup.com/vmware/index.html). So the examples
> will only be using VirtualBox as this does not require a paid for plugin.

First we need to create the folder structure and initialize the Vagrant environments
based on our needs:

```bash
mkdir -p ~/projects/Vagrant-testing/VirtualBox/Ubuntu/16.04
mkdir -p ~/projects/Vagrant-testing/VMware/Ubuntu/16.04
cd ~/projects/Vagrant-testing/VirtualBox/Ubuntu/16.04
vagrant init ubuntu1604-packer-template-virtualbox
cd ~/projects/Vagrant-testing/VMware/Ubuntu/16.04
vagrant init ubuntu1604-packer-template-vmware
```

Now we are ready to spin up the Vagrant environment which we would like to begin
testing with:

```raw
cd ~/projects/Vagrant-testing/VirtualBox/Ubuntu/16.04
vagrant up
...
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'ubuntu1604-packer-template-virtualbox'...
==> default: Matching MAC address for NAT networking...
==> default: Setting the name of the VM: 1604_default_1520868963557_57262
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
    default: The guest additions on this VM do not match the installed version of
    default: VirtualBox! In most cases this is fine, but in rare cases it can
    default: prevent things such as shared folders from working properly. If you see
    default: shared folder errors, please make sure the guest additions within the
    default: virtual machine match the version of VirtualBox you have installed on
    default: your host and reload your VM.
    default:
    default: Guest Additions Version: 5.0.40
    default: VirtualBox Version: 5.2
==> default: Mounting shared folders...
    default: /vagrant => /Users/larry/projects/Vagrant-testing/VirtualBox/Ubuntu/16.04
```

Once the above completes you are ready to begin your testing. We can SSH to the
box to work within the Vagrant environment:

```bash
vagrant ssh
```

You are now ready to do whatever you would like with your testing.

And when you are done with your testing you can easily tear down the Vagrant
environment:

```bash
vagrant destroy
...
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
```

### VMware Fusion Export To vSphere

This method will build a local VM using VMware Fusion but will export the image
as a vSphere template when complete.

#### CentOS 6

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=centos6.json centos_fusion_esx.json
```

#### CentOS 7

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=centos7.json centos_fusion_esx.json
```

#### Ubuntu 12.04

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=ubuntu1204.json ubuntu_fusion_esx.json
```

#### Ubuntu 14.04

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=ubuntu1404.json ubuntu_fusion_esx.json
```

#### Ubuntu 16.04

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=ubuntu1604.json ubuntu_fusion_esx.json
```

### VMware vSphere

This method will build VM templates using Packer directly on a vSphere host and
then convert to a template via vCenter.

#### CentOS 6

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=centos6.json centos_esx.json
```

#### CentOS 7

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=centos7.json centos_esx.json
```

#### Ubuntu 12.04

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=ubuntu1204.json ubuntu_esx.json
```

#### Ubuntu 14.04

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=ubuntu1404.json ubuntu_esx.json
```

#### Ubuntu 16.04

```bash
packer build -var-file=private_variables.json -var-file=variables.json -var-file=ubuntu1604.json ubuntu_esx.json
```

## License

MIT

## Author Information

Larry Smith Jr.

-   [EverythingShouldBeVirtual](http://everythingshouldbevirtual.com)
-   [@mrlesmithjr](https://www.twitter.com/mrlesmithjr)
-   <mailto:mrlesmithjr@gmail.com>
