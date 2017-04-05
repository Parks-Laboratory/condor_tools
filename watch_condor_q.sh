#! /bin/sh

# Usage ./watch_condor_q [options]
# e.g. ./watch_condor_q -dag
while true; do
     condor_q $*
     sleep 10
done
