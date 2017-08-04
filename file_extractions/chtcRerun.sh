#! /bin/sh

if [ $# -lt 4 ]
then
        echo "Please enter (trait) (epistasis_submit_filename) (memory_size) (group_size) (-c or not)"
else
        echo "Have you ran chtcExtract (trait) dagman?"
        echo "If you have, did you enter the correct format - (trait) (epistasis_submit_filename) (memory_size) (group_size) (-c or not)?"
        select yn in "Yes" "No";
        do
                case $yn in
                        Yes )

                                i='\"y\"';
                                echo "Finding offset for ${1}"
                                benchmark=`ssh $USER@submit-3.chtc.wisc.edu "
                                tail -1 epistasis_$1.sub
                                exit
                                "`;
                                IFS=' ' read -r -a arr <<< "$benchmark";
                                offset=$((${arr[6]}-1));
                                echo "The final offset for ${1} is ${offset}";
                                ssh -X $USER@submit-3.chtc.wisc.edu "
                                echo "Copying writeFailedJobs.py to ./epistasis_results/${1}"
                                cp writeFailedJobs.py ./epistasis_results/$1
                                cd ./epistasis_results/$1
                                echo "Running writeFailedJobs.py with ${offset}"
                                python writeFailedJobs.py "$offset"
                                cd ..
                                cd ..
                                echo "Copying failed.txt to data folder"
                                cp "./epistasis_results/${1}/failed.txt" ./data
                                echo "Running $2"
                                echo "Command line is python "$2" "$1" --rerun failed.txt -m "$3" -g "$4" "$5""
                                echo "$i" | python "$2" "$1" --rerun failed.txt -m "$3" -g "$4" "$5"
                                exit";
                                break;;
                        No)
                                exit;;
                esac
        done
fi
