# Note: depends on Rscript (comes with R installation)

if [ $# -ne 1 ]; then
	echo Usage: $0 path/to/chtc/log_file
	exit
fi

function printds {
	echo -e $* \\n
}

function countJobs {
	echo $(grep ^"$2" $1 | wc -l)
}

printds \\n===============================================

echo 'Number jobs completed/submitted:' $(countJobs $1 005) / $(countJobs $1 000)
echo 'Number jobs put on hold/re-submitted:' $(countJobs $1 012) / $(countJobs $1 013)
echo 'Number jobs evicted:' $(countJobs $1 004)
echo 'Number jobs w/ non-zero exit codes:' $(countJobs $1 "Normal termination (return value -*[1-9]")


if [ ! -x "$(command -v Rscript)" ]; then
	echo -e "\\n(Additional statistics available if Rscript is installed)"
	printds \\n===============================================
	exit
fi

echo 'args=commandArgs(trailingOnly = TRUE);
summary(scan(args[1])/as.numeric(args[2]))' > summarize.R
printds \\n===============================================

grep 'Disk (KB)' $1 > lines
echo "Disk Usage (MB):"
awk '{print $4}' lines > col
Rscript summarize.R col 1000
echo
echo "Disk Allocation (MB):"
awk '{print $6}' lines > col
Rscript summarize.R col 1000

printds \\n===============================================

grep 'Memory (MB)' $1 > lines
echo "Memory Usage (MB):"
awk '{print $4}' lines > col
Rscript summarize.R col 1
echo
echo "Memory Allocation (MB):"
awk '{print $6}' lines > col
Rscript summarize.R col 1

printds \\n===============================================

echo 'Job duration (ignore dates)'
grep 'Total Remote Usage' $1 > lines
awk 'match($3, /([^,]*)/, a) {print a[1]}' lines > col
echo 'args=commandArgs(trailingOnly = TRUE); summary(strptime(scan(args[1],
	what="character"), format="%H:%M:%S"))' > summarizeTime.R
Rscript summarizeTime.R col

printds \\n===============================================





rm lines col summarize.R summarizeTime.R
