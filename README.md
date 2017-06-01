# Purpose
Tools for making portable installations, monitoring jobs, and in general interacting with CHTC condor. See [**general information for interacting with Condor**](condor.md)

## Description of scripts
* *log_summary.sh* reads the .log file output by Condor and displays statistics on the jobs
  <details><summary>Sample output</summary><pre>
  ===============================================

  Number jobs completed/submitted: 29 / 128
  Number jobs put on hold/re-submitted: 9 / 0
  Number jobs evicted: 2
  Number jobs w/ non-zero exit codes: 0

  ===============================================

  First job submitted on 04/24 11:14:54
  Last job finished on 04/24 11:24:08

  Time difference of 9.233333 mins
  Total time executing: 55.1 mins

  ===============================================

  Job duration (successful runs only, ignore dates)
                   Min.               1st Qu.                Median
  "2017-06-01 00:01:13" "2017-06-01 00:01:23" "2017-06-01 00:01:40"
                   Mean               3rd Qu.                  Max.
  "2017-06-01 00:01:52" "2017-06-01 00:02:15" "2017-06-01 00:03:31"

  ===============================================

  Disk Usage (MB):
     Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
    854.7  1066.0  1151.0  1176.0  1293.0  1426.0

  Disk Allocation (MB):
     Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
     2186    6914   32640   32140   34420  179500

  ===============================================

  Memory Usage (MB):
     Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
      2.0     3.0     4.0   434.6     4.0  4776.0

  Memory Allocation (MB):
     Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
     4096    4096    4096    5156    4096   16130

  ===============================================
  </pre></details>
