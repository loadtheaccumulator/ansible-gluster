ansible-gluster
===============

Ansible modules and example playbooks for deploying Gluster

This documentation currently covers the examples in the examples/ex_auto_vars-full directory.
The examples in the other directories work, but were stepping stones to get to the current varfile based version.


#### Prereqs:

1. Gluster packages are installed on all servers and glusterd is running. (future ansible-gluster feature)
    This is taken care of automatically if the servers are running Red Hat Gluster Storage.
    For now, refer to the documentation at gluster.org for setting up on other distributions.

2. SSH keys are setup on all servers and Ansible is able to run commands against them.

3. The servers have similar disk configurations with identical unused partitions across all servers.

4. To use the example playbooks (as is), you will need the number of systems (VM or baremetal) per the list below...
    Each volume type below will require at least one additional system for the client mount.
        - replicated volume requires                        2 systems
        - distributed or distributed-replicated volume      4 systems
        - geo-rep volume requires                           4 systems
        - geo-rep cascading requires                        6 systems

    NOTE: If you setup seven systems (VM or BM) with IPs numbered 192.168.1.221 through 192.168.1.227,
            you will be able to use the playbooks without modifying the hostfiles.
            In my lab setup, I created nine VMs running Red Hat Gluster Storage 3.0.
            Systems #8 and #9 allowed me to play with simultaneously mounting volumes on multiple clients (optional).


### Setting up:

1. On your ansible management system (can be your laptop or workstation), git clone the ansible-gluster repository or download and unzip.

    ```
    $ git clone https://github.com/loadtheaccumulator/ansible-gluster.git
    ```

2. Add the path to the ansible-gluster directory created in step 1 to the Ansible library path.

    ```
    $ export ANSIBLE_LIBRARY=/path/to/ansible-gluster:/usr/share/ansible
    ```

3. Edit the example host files to specify the hostnames of your servers and comment/delete any unused systems.

      e.g., in the examples/ex_auto_vars-full/distributed/hosts file replace 192.168.1.221 through 192.168.1.229 with the hostnames or IPs of your systems...

    ```
    [MASTERNODE]
    192.168.1.221

    [PEERS]
    192.168.1.222
    192.168.1.223
    192.168.1.224

    [CLIENTS]
    192.168.1.227
    #192.168.1.228
    #192.168.1.229
    ```

    In the above example, list additional hosts in the PEERS and CLIENTS sections to scale the volume and mount on multiple client systems

4. Edit the example playbooks to specify the devices to be used for bricks.
    The glustervolume.yml, glustergeorep.yml, and glustergeorep_cascading.yml playbooks are designed to auto-discover /dev/sdb..sd(n) or /dev/vdb..vd(n), but if you have specific devices you want to use or you have single-disk systems, you can list the device names in the vars file.

    e.g., to use an unused partition /dev/sda3 and /dev/sda5 on the root disk of your servers, edit the examples/ex_auto_vars-full/distributed/vars.yml file and replace...

    ```
    # BRICK VARS
    # use if you require specific devices
    #   (e.g., single disk or existing environment)
    #pvnames:
    #- /dev/replaceme1
    #- /dev/replaceme2
    ```

    ... with ...

    ```
    # BRICK VARS
    # use if you require specific devices
    #   (e.g., single disk or existing environment)
    pvnames:
    - /dev/sda3
    - /dev/sda5
    ```

5. Take an example playbook for a spin. From the root of the ansible-gluster directory, run the command...

    ```
    $ ./do_example.sh create volume distributed
    ```

    ... or, you can use the full ansible-playbook command (same command used in the do_example script)...

    ```
    ansible-playbook -i examples/ex_auto_vars-full/distributed/hosts -vv \
                        examples/ex_auto_vars-full/glustervolume.yml \
                        --extra-vars="varfile=distributed/vars.yml"
    ```

    The available commands are...
    - do_example.sh create volume distributed
    - do_example.sh create volume distributed-replicated
    - do_example.sh create volume replicated
    - do_example.sh create georep georep
    - do_example.sh create georep_cascading georep_cascading

    NOTE: Yeah yeah yeah, the "georep georep" sounds redundant, but the first var is the type and the second is the sub-directory.
          You can customize by copying the georep directory and passing the new directory name in the above command.
          (the command syntax is do_example.sh create|destroy type subdirectory)

6. Check the volume.

    ```
    $ ansible MASTERNODE -i /examples/ex_auto_vars-full/distributed/hosts -a "gluster volume info"
    ```

7. To undo everything and destroy the gluster cluster you just setup...

    NOTE: THIS IS DESTRUCTIVE AND COULD DESTROY ALL VOLUMES, MOUNTS, LVM CONFIGS, AND THE KNOWN UNIVERSE! PROCEED WITH CAUTION!!!

    ```
    $ ./do_example.sh destroy volume distributed
    ```

    ... or, you can use the full ansible-playbook command (same command used in the do_example script)...

    ```
    ansible-playbook -i examples/ex_auto_vars-full/distributed/hosts -vv \
                        examples/ex_auto_vars-full/ex_destroy_glustervolume.yml \
                        --extra-vars="varfile=distributed/vars.yml"
    ```

    The available commands are...
    - do_example.sh destroy volume distributed
    - do_example.sh destroy volume distributed-replicated
    - do_example.sh destroy volume replicated
    - do_example.sh destroy georep georep
    - do_example.sh destroy georep_cascading georep_cascading


### TODO:
- Add documentation on the specific module and playbook features (existing and still todo)
- Update "changed" key/value to reflect actual status


