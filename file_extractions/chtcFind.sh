#! /bin/sh

if [ -z "$1" ]
then
        echo Please enter a trait name
else
        echo Counting total number of .gwas files...
        output=`ssh $USER@submit-3.chtc.wisc.edu "
        find ./epistasis_results/$1 -type f -name '*.gwas' | wc -l
        exit"`
        echo "Total number of .gwas files in directory: " $output
        echo Finding total number of jobs submitted in .sub file...
        benchmark=`ssh $USER@submit-3.chtc.wisc.edu "
        tail -1 epistasis_$1.sub
        exit
        "`
        IFS=' ' read -r -a arr <<< "$benchmark"
        echo "Total number of jobs submitted is: " ${arr[6]}
fi
