ansible-gluster
===============

Ansible modules for deploying Gluster

### Assumptions:

As of this writing, the assumptions are:

1. Gluster packages are installed on all servers and glusterd is running. (future ansible-gluster feature)
      This is taken care of if the servers are running Red Hat Storage Server.

2. SSH keys are setup on all servers and Ansible is able to run commands against them.

3. The servers have similar disk configurations with identical unused partitions across all servers.

4. The disks to be used have been partitioned with at least one partition. (future ansible-gluster feature)

To use the example playbooks, you will need at least two servers (baremetal or virtual) for the replicated example and, at most, six for the cascading geo-replication examples.

### Setting up:

1. On your ansible system, git clone the ansible-gluster repository or download and unzip.

2. To run the examples, you will need to add the path to the ansible-gluster directory to the Ansible library path.

    ```
     $ export ANSIBLE_LIBRARY=/path/to/ansible-gluster:/usr/share/ansible
    ```

3. Edit the example host files to specify the hostnames of your servers.

      e.g., in the ex_hosts_distrep file replace server1.example.com and server2.example.com with the hostnames of two of your servers...

    ```
    [MASTERNODE]
    server1.example.com

    [PEERS]
    server2.example.com
    ```

4. Edit the example playbooks to specify the devices to be used for bricks.

    e.g., to use an unused partition /dev/sda6 on the root disk of your servers, in the ex_replicated_volume.yml file replace...

    ```
    pvnames:
      - /dev/sdb1
    ```

    ... with ...

    ```
    pvnames:
      - /dev/sda6
    ```

5. Take an example playbook for a spin.

    ```
    $ cd examples
    $ ansible-playbook -i ex_hosts_distrep -v ex_replicated_volume.yml
    ```

6. Login to the server listed under [MASTERNODE] and check the volume.

    ```
    # gluster volume info
    ```
