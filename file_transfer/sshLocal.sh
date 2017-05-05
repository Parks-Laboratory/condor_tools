# figure out username
user=""
if [ -z "$USER" ]; then
	user=$USERNAME;
else
	user=$USER;
fi

hitenter=$'\n'

echo MAKE NEW PUBLIC KEY
ssh-keygen -t rsa <<< "${hitenter}${hitenter}${hitenter}"

echo COPY PUBLIC KEY TO DESTINATION HOST
scp ~/.ssh/id_rsa.pub sshDest.sh $user@submit-3.chtc.wisc.edu:

echo SSH TO DESTINATION HOST
ssh $user@submit-3.chtc.wisc.edu
