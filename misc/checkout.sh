# Usage: ./checkout.sh dirname dirname_versionName
#
# For a directory (dir) quickly alternate between several sets of content that
# dir could contain. Useful for testing using several sets of alternative data.
#
# WARNING: overwrites contents of dir
#
# Example:
# Suppose version="FOO" and dir="DIR"
#
# Suppose that initially, before running the script:
# DIR contains version 1
# DIR_FOO contains version 1
# DIR_BAR contains version 2
# DIR_BAZ contains version 3
#
# $ ./checkout DIR BAR
# DIR contains version 2
# DIR_FOO contains version 1
# DIR_BAR contains version 2
# DIR_BAZ contains version 3


dir=$1
version=$2

numExpectedArgs=2
if [ $# -ne $numExpectedArgs ]; then
	echo Usage: $0 some_arg
	exit
fi

archive=$dir"_"$version
if [ -d "$archive" ]; then
	rm -r "$dir"
	mv "$archive" "$dir"
else
	echo swap failed, either \"$archive\" was missing
fi
