#! /bin/sh

# Usage: $ chtcExtract (trait_name) (attribute)(pulls fastlmm_*.sub, *.sh, .log and all .gwas files from fastlmm_results, vice versa for epistasis)
# Effect: Creates LOG_FILES folder with only .log files, RESULTS folder with all .gwas files, deletes all files except those needed in the directories
if [ -z "$1" ]
then
        echo Please enter a trait, followed by epistasis, fastlmm, dagman, dagmanrerun
else
        if [ -z "$2" ]
        then
                echo Please enter either "epistasis", "fastlmm", "dagman", "dagmanrerun" to extract the required files
        else
                if [ "$2" == "fastlmm" ]
                then
                        ssh $USER@submit-3.chtc.wisc.edu "
                        find ./fastlmm_condor_out/$1/ -type f ! -name '*.log' -delete
                        find ./fastlmm_results/$1/ -type f ! -name '*.gwas' -delete
                        echo Deleting non .log and .gwas files from fastlmm directories...
                        exit"
                        mkdir FASTLMM_OUTPUT
                        cd FASTLMM_OUTPUT
                        scp -r $USER@submit-3.chtc.wisc.edu:fastlmm_$1.sh .
                        scp -r $USER@submit-3.chtc.wisc.edu:fastlmm_$1.sub .
                        scp -r $USER@submit-3.chtc.wisc.edu:fastlmm_results/$1/ ./RESULTS
                elif [ "$2" == "epistasis" ]
                then
                        mkdir EPISTASIS_OUTPUT
                        cd EPISTASIS_OUTPUT
                        ssh $USER@submit-3.chtc.wisc.edu "
                        find ./epistasis_condor_out/$1/ -type f ! -name '*.log' -delete
                        find ./epistasis_results/$1/ -type f ! -name '*.gwas' -delete
                        echo Deleting non .log and .gwas files from epistasis directories...
                        exit"
                        scp -r $USER@submit-3.chtc.wisc.edu:epistasis_results/$1/ ./RESULTS
                elif [ "$2" == "dagman" ]
                then
                        mkdir DAGMAN_LOG_FILES
                        cd DAGMAN_LOG_FILES
                        scp -r $USER@submit-3.chtc.wisc.edu:epistasis_$1.dag.nodes.log .
                        scp -r $USER@submit-3.chtc.wisc.edu:epistasis_$1.sub .
                        scp -r $USER@submit-3.chtc.wisc.edu:epistasis_$1.sh .
                elif [ "$2" == "dagmanrerun" ]
                then
                        mkdir DAGMAN_RERUN_LOG_FILES
                        cd DAGMAN_RERUN_LOG_FILES
                        scp -r $USER@submit-3.chtc.wisc.edu:epistasis_$1_rerun.dag.nodes.log .
                        scp -r $USER@submit-3.chtc.wisc.edu:epistasis_$1_rerun.sh .
                        scp -r $USER@submit-3.chtc.wisc.edu:epistasis_$1_rerun.sub .
                else
                        echo Enter either epistasis, fastlmm, dagman or dagmanrerun
                fi
        fi
fi
