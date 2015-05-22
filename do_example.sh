#!/bin/bash

# Jonathan Holloway <loadtheaccumulator@gmail.com>
#

action=$1       # create, destroy
type=$2         # volume, georep, georep_cascading
dir=$3          # distributed, replicated, distributed-replicated, georep, georep_cascading

if [ $action == "create" ]
then
    ansible-playbook -i examples/ex_auto_vars-full/${dir}/hosts -vv \
                        examples/ex_auto_vars-full/gluster${type}.yml \
                        --extra-vars="varfile=${dir}/vars.yml"
fi

if [ $action == "destroy" ]
then
    ansible-playbook -i examples/ex_auto_vars-full/${dir}/hosts -vv \
                        examples/ex_auto_vars-full/ex_destroy_gluster${type}.yml \
                        --extra-vars="varfile=${dir}/vars.yml"
fi

