#! /bin/sh

if [ -z "$1" ]
then
        echo Please enter a trait
else
        echo "This function will remove all fastlmm, epistasis and dagman files associated with the trait"
        echo "Do you wish to continue? Type 1 or 2"
        select yn in "Yes" "No";
        do
                case $yn in
                        Yes )
                                ssh $USER@submit-3.chtc.wisc.edu "
                                echo Deleting data folder and possible failed.txt file
                                rm data/$1.*
                                rm data/failed.txt
                                echo Deleting fastlmm files for $1
                                rm fastlmm_$1.*
                                rm -rf fastlmm_results/$1
                                rm -rf fastlmm_condor_out/$1
                                echo Deleting epistasis and dagman files for $1
                                rm epistasis_$1*
                                rm -rf epistasis_results/$1
                                rm -rf epistasis_condor_out/$1
                                exit";
                                echo Remove operation on chtc done;
                                break;;
                        No ) exit;;
                esac
        done
fi
