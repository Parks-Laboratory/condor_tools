# Usage: ./swapdata.sh
#
# For a directory with unchanging name, quickly alternate between one set of
# contents and another. Useful for testing using alternative data, and then
# switching back to the actual data when testing is done.
#
# Given 2 versions of a directory (dir), backup the current version of dir
# and replace the contents of dir with contents of the other version.
#
# Example:
# Suppose version1="FOO" and version2="BAR", and dir="DIR"
#
# Initially, before running the script:
# DIR contains version 1
# DIR_BAR contains version 2
#
# After running the script for the first time:
# DIR contains version 2
# DIR_FOO contains version 1
#
# After running the script again, we're back to the initial state:
# DIR contains version 1
# DIR_BAR contains version 2


dir="data"						# set this to name of main directory
version1="1600"					# description of version 1 of dir
version2="full"					# description of version 2 of dir

function checkerror {
	if [ ! $? -eq 0 ]; then
		echo swap failed
	fi
}

function swap {
	outgoing=$1
	incomming=$2

	mv "$dir" "$outgoing"
	checkerror
	mv "$incomming" "$dir"
	checkerror
}

if [ ! -d "$dir" ]; then
	echo "Can't swap, \"$dir\" doesn't exist"
	exit
fi

archive1=$dir"_"$version1
archive2=$dir"_"$version2

if [[ -d "$archive1" && ! -d "$archive2" ]]; then
	swap $archive2 $archive1
elif [[ -d "$archive2" && ! -d "$archive1" ]]; then
	swap $archive1 $archive2
else
	echo swap failed, either \"$archive1\" or \"$archive2\" was missing or both were present
fi
