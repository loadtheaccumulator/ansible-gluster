ansible-gluster
===============

Ansible modules for deploying Gluster

### Assumptions:

As of this writing, the assumptions are:

1. Gluster packages are installed on all servers and glusterd is running. (future ansible-gluster feature)
      This is taken care of if the servers are running Red Hat Storage Server.

2. SSH keys are setup on all servers and Ansible is able to run commands against them.

3. The servers have similar disk configurations with identical unused partitions across all servers.

To use the example playbooks, you will need at least two servers (baremetal or virtual) for the replicated example and, at most, six for the cascading geo-replication examples.

### Setting up:

1. On your ansible system, git clone the ansible-gluster repository or download and unzip.

2. To run the examples, you will need to add the path to the ansible-gluster directory to the Ansible library path.

    ```
     $ export ANSIBLE_LIBRARY=/path/to/ansible-gluster:/usr/share/ansible
    ```

3. Edit the example host files to specify the hostnames of your servers.

      e.g., in the examples/ex_hosts_distrep file replace server1.example.com and server2.example.com with the hostnames of two of your servers...

    ```
    [MASTERNODE]
    server1.example.com

    [PEERS]
    server2.example.com
    ```

4. Edit the example playbooks to specify the devices to be used for bricks.

    NOTE: This is only necessary for the examples in the examples/ex_manual/ or if you want to use partitions on your root disk

    e.g., to use an unused partition /dev/sda6 on the root disk of your servers, in the manual/ex_replicated_volume.yml file replace...

    ```
    pvnames:
      - /dev/replaceme1
    ```

    ... with ...

    ```
    pvnames:
      - /dev/sda6
    ```

5. Take an example playbook for a spin.

    ```
    $ cd examples
    $ ansible-playbook -i ex_hosts_distrep -vv ex_manual/ex_replicated_volume.yml
    ```

6. Login to the server listed under [MASTERNODE] and check the volume.

    ```
    # gluster volume info
    ```

7. To undo everything and destroy the gluster cluster you just setup...

    NOTE: THIS IS DESTRUCTIVE AND COULD DESTROY ALL VOLUMES, MOUNTS, LVM CONFIGS, AND THE KNOWN UNIVERSE! PROCEED WITH CAUTION!!!

    ```
    $ ansible-playbook -i ex_hosts_distrep -vv ex_manual/ex_destroy_distributed-replicated.yml
    ```


