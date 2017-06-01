# Description of files
## Misc.
* **.bashrc** contains fromchtc and tochtc functions that can be run in bash to facilitate file transfer to CHTC submit server. 
	* Add the contents of this file to your ~/.bashrc file to use these commands from the bash command line:
		1. `vim ~/.bashrc`
		1. enter text-editing mode: `I`
		1. paste the contents of this *.bashrc* into the top of the file (right-click > paste, or Shift + Insert)
		1. save the file: `wq`
		1. reload bash: `bash`

## Setting up SSH to skip password prompt
* **sshLocal.sh** creates a new key for use with SSH, and transfers the new key to the CHTC submit server
	* if it prompts you for a passphrase, just hit enter 
* **sshDest.sh** (copied to CHTC submit server by sshLocal.sh) adds the key created by sshLocal.sh to the submit-server's list of authorized keys
