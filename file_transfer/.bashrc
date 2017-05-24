# Add these lines to the file located at ~/.bashrc

alias tochtc=to_chtc
alias fromchtc=from_chtc

user=""
if [ -z "$USER" ]; then
	user=$USERNAME;
else
	user=$USER;
fi

# Usage: $ tochtc file1 file2 ...
function to_chtc {
        scp -r $* $user@submit-3.chtc.wisc.edu:
}

# Usage: $ fromchtc file1 file2 ...
function from_chtc {
        for i in $*; do
                scp -r $user@submit-3.chtc.wisc.edu:$i .
        done
}
