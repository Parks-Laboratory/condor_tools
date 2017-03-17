# Add these lines to the file located at ~/.bashrc

alias tochtc=to_chtc
alias fromchtc=from_chtc

# Usage: $ tochtc file1 file2 ...
function to_chtc {
        scp -r $* cgottsacker@submit-3.chtc.wisc.edu:
}

# Usage: $ fromchtc file1 file2 ...
function from_chtc {
        for i in $*; do
                scp -r cgottsacker@submit-3.chtc.wisc.edu:$i .
        done
}
