# Description
Tools for making portable installations, monitoring jobs, and in general interacting with CHTC condor

## Condor CLI:
(see http://research.cs.wisc.edu/htcondor/manual/current/11_Command_Reference.html)

	condor_q
		View user's jobs in the queue
		Options:
			-hold
				View jobs being held, and the reason why they are on hold
	condor_release $USER
		Restart all jobs for $USER that were put on hold
	condor_rm [<job #> | $USER]
		if $USER is specified instead of job#, all jobs submitted by user are removed
	condor_submit <submit file>.sub
	codor_submit -i <interactive submit file>.sub

## Condor log files codes:
	000: Job submitted
		000 (82549230.000.000) 03/03 15:12:32 Job submitted from host: <128.104.100.44:9618?addrs=128.104.100.44-9618+[2607-f388-107c-501-90e2-baff-fe2c-2724]-9618&noUDP&sock=4629_affc_3>
	001: Job executing
		001 (82549230.000.000) 03/03 15:13:33 Job executing on host: <131.225.189.241:64433?CCBID=128.104.100.30:9640%3faddrs%3d128.104.100.30-9640#2895865&addrs=131.225.189.241-64433&noUDP>

		uaddrs = set([x.split()[8].split('?')[0].split('<')[1].split(':')[0] for x in lines])
		cmd = ['(Machine == "{}")'.format(x) for x in uaddrs]

	002:
	003:
	004:
	005: Job terminated
		005 (82549230.000.000) 03/03 15:13:48 Job terminated.
			(1) Normal termination (return value 0)
				Usr 0 00:00:07, Sys 0 00:00:01  -  Run Remote Usage
				Usr 0 00:00:00, Sys 0 00:00:00  -  Run Local Usage
				Usr 0 00:00:07, Sys 0 00:00:01  -  Total Remote Usage
				Usr 0 00:00:00, Sys 0 00:00:00  -  Total Local Usage
			999283  -  Run Bytes Sent By Job
			655  -  Run Bytes Received By Job
			999283  -  Total Bytes Sent By Job
			655  -  Total Bytes Received By Job
			Partitionable Resources :    Usage  Request Allocated
			   Cpus                 :                 1         1
			   Disk (KB)            :   925944  4194304  35008281
			   Memory (MB)          :        4     8000      8000
	006: Image size of job updated
		006 (82549230.000.000) 03/03 15:13:41 Image size of job updated: 40648
			4  -  MemoryUsage of job (MB)
			3736  -  ResidentSetSize of job (KB)
	007: Exception
		007 (82567314.3993.000) 03/09 12:52:49 Shadow exception!
			Error from slot1_8@spalding10.chtc.wisc.edu: STARTER at 128.104.58.19 failed to receive file /var/lib/condor/execute/slot1/dir_2198784/epistasis.tar.gz: FILETRANSFER:1:non-zero exit(13312) from /usr/libexec/condor/curl_plugin
			0  -  Run Bytes Sent By Job
			0  -  Run Bytes Received By Job
	012: Job was held
		012 (82567314.3993.000) 03/09 12:52:49 Job was held.
			Error from slot1_8@spalding10.chtc.wisc.edu: STARTER at 128.104.58.19 failed to receive file /var/lib/condor/execute/slot1/dir_2198784/epistasis.tar.gz: FILETRANSFER:1:non-zero exit(13312) from /usr/libexec/condor/curl_plugin
			Code 12 Subcode 0


## Tips:
* to get resource usage, the job must terminate naturally (no errors), so, give it plenty of resources the first time to see how much RAM and disk space it needs, then cut it back on subsequent jobs.
