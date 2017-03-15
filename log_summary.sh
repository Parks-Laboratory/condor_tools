if [ $# -ne 1 ]; then
	echo Usage: $0 path/to/chtc/log_file
	exit
fi

echo 'args=commandArgs(trailingOnly = TRUE); summary(scan(args[1])/as.numeric(args[2]))' > summarize.R
echo ===============================================

grep 'Disk (KB)' $1 > lines
echo "Disk Usage (MB):"
awk '{print $4}' lines > col
Rscript summarize.R col 1000
echo
echo "Disk Allocation (MB):"
awk '{print $6}' lines > col
Rscript summarize.R col 1000

echo ===============================================

grep 'Memory (MB)' $1 > lines
echo "Memory Usage (MB):"
awk '{print $4}' lines > col
Rscript summarize.R col 1
echo
echo "Memory Allocation (MB):"
awk '{print $6}' lines > col
Rscript summarize.R col 1

echo ===============================================

echo 'Job duration (ignore dates)'
grep 'Total Remote Usage' $1 > lines
awk 'match($3, /([^,]*)/, a) {print a[1]}' lines > col
echo 'args=commandArgs(trailingOnly = TRUE); summary(strptime(scan(args[1], what="character"), format="%H:%M:%S"))' > summarizeTime.R
Rscript summarizeTime.R col


rm lines col summarize.R summarizeTime.R
