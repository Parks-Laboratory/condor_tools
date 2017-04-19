# Note: depends on Rscript (comes with R installation)

if [ $# -ne 1 ]; then
	echo Usage: $0 path/to/chtc/log_file
	exit
elif [ ! -f $1 ]; then
	echo Could not find file \"$1\"
	exit
fi

function printds {
	echo -e $* \\n
}

function countJobs {
	echo $(grep "$1" "$2" | wc -l)
}

printds \\n===============================================

echo 'Number jobs completed/submitted:' $(countJobs ^005 "$1") / $(countJobs ^000 "$1")
echo 'Number jobs put on hold/re-submitted:' $(countJobs ^012 "$1") / $(countJobs ^013 "$1")
echo 'Number jobs evicted:' $(countJobs ^004 "$1")
echo 'Number jobs w/ non-zero exit codes:' $(countJobs "Normal termination (return value [^0]" "$1")


if [ ! -x "$(command -v Rscript)" ]; then
	echo -e "\\n(Additional statistics available if Rscript is installed)"
	printds \\n===============================================
	exit
fi

echo '
args=commandArgs(trailingOnly = TRUE);
summary(scan(args[1], quiet=TRUE)/as.numeric(args[2]))
' > summarize.R

printds \\n===============================================

grep 'Disk (KB)' "$1" > lines
echo "Disk Usage (MB):"
awk '{print $4}' lines > col
Rscript summarize.R col 1000
echo
echo "Disk Allocation (MB):"
awk '{print $6}' lines > col
Rscript summarize.R col 1000

printds \\n===============================================

grep 'Memory (MB)' "$1" > lines
echo "Memory Usage (MB):"
awk '{print $4}' lines > col
Rscript summarize.R col 1
echo
echo "Memory Allocation (MB):"
awk '{print $6}' lines > col
Rscript summarize.R col 1

printds \\n===============================================

firstSubmission=$( grep ^000 "$1" | head -1 | awk '{print $3" "$4}' )
lastTermination=$( grep ^005 "$1" | tail -1 | awk '{print $3" "$4}' )
echo "First job submitted on $firstSubmission"
echo "Last job finished on $lastTermination"

echo '
args=commandArgs(trailingOnly = TRUE);
s=strptime(c(args[1], args[2]), format="%m/%d  %H:%M:%S");
s[2]-s[1];
' > getDuration.R

echo
Rscript getDuration.R "$firstSubmission" "$lastTermination"

grep 'Run Remote Usage' "$1" > lines
awk 'match($3, /([^,]*)/, a) {print a[1]}' lines > col
echo '
args=commandArgs(trailingOnly = TRUE);
t=strptime(scan(args[1],
what="character", quiet=TRUE), format="%H:%M:%S");
s=sum(c(t$hour*3600, t$min*60, t$sec));
if(s < 60) {
	cat(paste(s,"secs"));
} else if(s < 3600) {
	cat(paste(s/60,"mins"));
} else if(s < 3600*24) {
	cat(paste(s/3600,"hours"));
} else if(s < s/(3600*24*365)){
	cat(paste(s/(3600*24),"days"));
} else {
	cat(paste(s/(3600*24*365),"years"));
}
' > runtime.R
echo "Total time executing: $(Rscript runtime.R col)"

printds \\n===============================================


echo 'Job duration (successful runs only, ignore dates)'
grep 'Total Remote Usage' "$1" > lines
awk 'match($3, /([^,]*)/, a) {print a[1]}' lines > col

echo '
args=commandArgs(trailingOnly = TRUE);
summary(strptime(scan(args[1], what="character", quiet=TRUE), format="%H:%M:%S"))
' > summarizeTime.R

Rscript summarizeTime.R col


printds \\n===============================================




rm lines col summarize.R getDuration.R summarizeTime.R runtime.R
