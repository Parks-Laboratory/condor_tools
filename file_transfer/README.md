# Description of files
## Misc.
* **.bashrc** contains fromchtc and tochtc functions that can be run in bash to facilitate file transfer to CHTC submit server. Add the contents of this file to your ~/.bashrc file

## Setting up SSH to skip password prompt
* **sshLocal.sh** creates a new key for use with SSH, and transfers the new key to the CHTC submit server
	* if it prompts you for a passphrase, just hit enter 
* **sshDest.sh** (copied to CHTC submit server by sshLocal.sh) adds the key created by sshLocal.sh to the submit-server's list of authorized keys
