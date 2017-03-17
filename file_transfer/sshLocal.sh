echo MAKE NEW PUBLIC KEY
ssh-keygen -t rsa
echo COPY PUBLIC KEY TO DESTINATION HOST
scp ~/.ssh/id_rsa.pub sshDest.sh $USER@submit-3.chtc.wisc.edu:
echo SSH TO DESTINATION HOST
ssh $USER@submit-3.chtc.wisc.edu
