echo UPDATE LIST OF AUTHORIZED KEYS
cat id_rsa.pub >> ~/.ssh/authorized_keys
echo MODIFY FILE PERMISSIONS
chmod 0700 ~
chmod 0700 ~/.ssh
chmod 0600 ~/.ssh/authorized_keys
