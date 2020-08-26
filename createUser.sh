#!/bin/bash

echo "Username: "
read username

if [ -z $username ]
then
    echo "You need to input a username"
else

    echo "Creating user..."
    adduser $username
    
    echo "Giving the permission to sudo scaling..."
    usermod -aG sudo $username
    echo ${username//./}
    echo "$username ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${username//./}
    chmod 0440 /etc/sudoers.d/${username//./}

    echo "Creating .ssh folder..."
    mkdir /home/$username/.ssh

    echo "Grant the correct permissions to .ssh folder..."
    chown -R $username /home/$username/.ssh && chmod -R 700 /home/$username/.ssh

    echo "Creating authorized_keys file..."
    touch /home/$username/.ssh/authorized_keys

    echo "Grant the correct permissions to authorized_keys file"
    chmod 600 /home/$username/.ssh/authorized_keys

    echo "Generating PEM file..."
    sudo -u $username ssh-keygen -t rsa -C "$username"

    echo "Transforming PEM file in a SSH file"
    cat /home/$username/.ssh/id_rsa.pub > /home/$username/.ssh/authorized_keys

    echo "Done! Save the string above has a .pem file:"
    sudo -u $username cat /home/$username/.ssh/id_rsa
fi