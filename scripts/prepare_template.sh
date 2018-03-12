#!/bin/bash

set -e
set -x

# # Add usernames to add to /etc/sudoers for passwordless sudo
# users=("ubuntu" "admin")
#
# for user in "${users[@]}"
# do
#   cat /etc/sudoers | grep ^$user
#   RC=$?
#   if [ $RC != 0 ]; then
#     bash -c "echo \"$user ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers"
#   fi
# done
