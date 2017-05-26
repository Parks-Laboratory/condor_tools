#!/usr/bin/env python

"""
Generates Submit Files and Processes Inputs/Outputs to Cluster
"""
from __future__ import division
import sys
import os
import pwd
import stat
import re
import subprocess
from math import log10, ceil
import textwrap
import operator
from datetime import datetime
import time
import re

def run(params, flags):
	os.chdir(root)
	make_output_dirs(params)

	if params['jobs_to_rerun_filename']:
		params['num_jobs'] = get_num_jobs_to_rerun(params)
	else:
		params['num_jobs'] = get_num_jobs_to_run(params)

	write_submission_file(params, flags)
	write_shell_script(params, flags)

	package_SQUID_files(params)
	submit_jobs(params)

def write_submission_file(params, flags):
	# submit and executable files
	submit_template = textwrap.dedent(
	'''	# template Submit File

	universe = vanilla
	requirements = (OpSysMajorVer == 6)

	log = %(condor_output)s/template_$(Cluster).log
	error = %(condor_output)s/template_$(Cluster)_$(Process).err

	InitialDir = %(root)s/results/%(dataset)s
	executable = %(root)s/%(executable_filename)s
	arguments = $(Process)
	output = %(condor_output)s/template_$(Cluster)_$(Process).out

	should_transfer_files = YES
	when_to_transfer_output = ON_EXIT
	transfer_input_files = http://proxy.chtc.wisc.edu/SQUID/%(username)s/%(squid_zip)s

	request_cpus = 1
	request_memory = %(use_memory)sGB
	request_disk = 2GB

	# if Condor puts job on hold, retry every 5 minutes, up to 4 times
	periodic_release = ( JobRunCount < 5 ) && ( time() - EnteredCurrentStatus > 60*5 )

	# set number of times to re-run a job if script returns non-zero exit code
	max_retries=3

	# specify which computing pools should be used
	%(use_chtc)s
	%(use_osg)s
	%(use_uw)s

	queue %(num_jobs)s
	''')

	submit_file = open( params['submit_filename'], 'w')
	submit_file.write( (submit_template % params).replace(',,', ',') )
	submit_file.close()


def write_shell_script(params, flags):
	exec_template = textwrap.dedent(
	'''	#!/bin/bash

	cleanup(){
		rm -r -f *.py *.pyc *.tar.gz python %(jobs_to_rerun_filename)s
	}

	exit_on_failure(){
		exit_code=$?
		if [ ! $exit_code -eq 0 ]; then
			cleanup
			exit $exit_code
		fi
	}

	# untar files sent along by SQUID
	echo "UNTARRING SQUID FILE:"
	tar -xzvf %(squid_zip)s | head -50
	exit_on_failure

	# untar Python installation
	echo "UNTARRING PYTHON INSTALLATION:"
	tar -xzvf %(python_installation)s | head
	exit_on_failure

	# untar ATLAS linear algebra library
	echo "UNTARRING ATLAS LIBRARY:"
	tar -xzvf %(atlas_installation)s | head
	exit_on_failure

	# make sure the script will use your Python installation
	export PATH=$(pwd)/python/bin:$PATH
	exit_on_failure

	# tell python where the user's home directory is located
	export PYTHONUSERBASE=$(pwd)

	# make sure script can find ATLAS library
	export LD_LIBRARY_PATH=$(pwd)/atlas
	exit_on_failure

	# get debugging information immediately before running script
	%(debug_shell)s

	# run script
	python template_node.py %(dataset)s %(job_number)s %(debug)s
	exit_on_failure

	cleanup

	exit 0
	''')

	if params['jobs_to_rerun_filename']:
		# get job number from ($1 + 1)th line of rerun file, where $1 is the
		# process number passed by CHTC to the job
		params['job_number'] = '$(sed -n "$(( $1 + 1 ))"p %(jobs_to_rerun_filename)s)' % params
	else:
		# $1 is the CHTC process number and $2 is the offset (intended for use with DAGMan)
		params['job_number'] = '$1'

	params['debug_shell'] = ''
	if flags['debug']:
		params['debug_shell'] = textwrap.dedent('''
		echo ===================================================================
		echo ======================= DEBUGGING OUTPUT ==========================
		echo ===================================================================
		echo "TIMESTAMP: $(date)"
		echo "OS VERSION: $(cat /etc/*-release)"
		echo ===================================================================
		echo "FILES/DIRS. IN $(pwd):"
		ls
		echo ===================================================================
		echo "ENVIRONMENT VARIABLES:"
		set
		echo ===================================================================
		# check what programs are installed
		if [ -x "$(command -v docker)" ]; then
			echo 'docker installed'
		else
			echo 'docker not installed'
		fi
		echo ===================================================================
		tmp="simplePythonTest.py"

		# writes lines b/n the two "EOF" strings
		cat > $tmp << EOF
		x = 1
		print('Python installation seems to work')
		EOF

		# executes script that was just written to file
		python $tmp
		rm $tmp
		echo ===================================================================
		''')

	exec_file = open( params['executable_filename'], 'w')
	exec_file.write( exec_template % params )
	exec_file.close()

	# give script permission to execute
	subprocess.call('chmod +x %(executable_filename)s' % params, shell = True)


def make_output_dirs(params):
	if not os.path.exists(params['condor_output']):
		os.makedirs(params['condor_output'])

	if not os.path.exists(params['job_output']):
		os.makedirs(params['job_output'])


def package_SQUID_files(params):
	# Add large files to a tar archive file, which will be sent over by SQUID
	# create archive, append files to it
	subprocess.call('tar -cf %(squid_archive)s -C %(dataLoc)s/ .' % params, shell = True)
	subprocess.call('tar -f %(squid_archive)s -C %(prog_path)s --append .' % params, shell = True)
	# compress archive file
	subprocess.call('gzip < %(squid_archive)s > %(squid_zip)s' % params, shell = True)
	# place compressed archive file in the user's SQUID directory
	subprocess.call('rm %(squid_archive)s' % params, shell = True)
	if(subprocess.call('mv %(squid_zip)s /squid/%(username)s' % params, shell = True)):
		sys.exit('Failed to create %(squid_zip)s and copy it to squid directory' % params)


def submit_jobs(params):
	# submit jobs to condor
	condor_cluster = subprocess.Popen(['condor_submit', params['submit_filename'] ], stdout=subprocess.PIPE).communicate()[0]
	condor_cluster = re.search('\d{4,}', condor_cluster).group()
	print("Submitting Jobs to Cluster %s" % condor_cluster)
	log.send_output("%s was sent to cluster %s at %s" % (params['dataset'], condor_cluster, timestamp()))

def get_num_jobs_to_run(params):
	return 1

def get_num_jobs_to_rerun(params):
	num_jobs = 0
	with open(os.path.join(params['dataLoc'], params['jobs_to_rerun_filename'])) as f:
		for line in f.readlines():
			try:
				int(line.strip())	# raise exception if non-integer found
			except Exception as e:
				break;
			num_jobs += 1
		return num_jobs

if __name__ == '__main__':
	# input/output folders
	root = os.path.split(os.path.realpath(sys.argv[0]))[0]
	condor_output_root = os.path.join(root, 'condor_out')
	job_output_root = os.path.join(root, 'results')

	# script locations
	prog_path = os.path.join(root, 'scripts')


	import argparse
	parser = argparse.ArgumentParser(description='''Runs template on datasets found in specified location (looks in data/ by default).
''')

	parser.add_argument('dataset', help='dataset to process')

	parser.add_argument('-d', '--datadir', dest='datadir',
		help='specifies folder to search for raw data',
		default=os.path.join(root, 'data'), action='store')
	parser.add_argument('-m', '--memory', dest='memory',
		help='amount of RAM (in GB) requested per job',
		default=8, action='store', type=int)
	parser.add_argument('-p', '--pools', dest='pools',
		help='select from: chtc, osg, uw. E.g. -p chtc osg, to run on CHTC and OSG',
		default=['chtc','osg','uw'], choices=['chtc','osg','uw'], nargs='*')
	parser.add_argument('--debug',
		help="gather debugging information from run", action='store_true')
	parser.add_argument('--rerun', dest='jobs_to_rerun_filename', default='',
		help='file name containing list of process/job numbers to run', action = 'store')


	args = parser.parse_args()

	dataset = args.dataset[0]
	dataLoc = args.datadir
	memory = args.memory
	pools = args.pools
	debug = args.debug
	jobs_to_rerun_filename = args.jobs_to_rerun_filename

	flags = {
		'debug': debug,
	}

	params = {}
	# check_prefixes(dataLoc, dataset)
	squid_archive = dataset + '.tar'
	params.update({
		'root': root,
		'dataLoc': dataLoc,
		'dataset': dataset,
		'offset': 0,
		'job_output': os.path.join(job_output_root, dataset),
		'condor_output': os.path.join(condor_output_root, dataset),
		'squid_archive': squid_archive,
		'squid_zip': squid_archive + '.gz',
		'username': pwd.getpwuid(os.getuid()).pw_name,
		'python_installation': 'python.tar.gz',
		'atlas_installation': 'atlas.tar.gz',
		'executable_filename' : 'template_%s.sh' % dataset,
		'submit_filename': 'template_%s.sub' % dataset,
		'jobs_to_rerun_filename': jobs_to_rerun_filename,
		'debug': ['', '--debug'][debug],
		'prog_path':prog_path,
		'timestamp':datetime.ctime(datetime.now()),
		'maxthreads':'--maxthreads %s' % maxthreads,
		'feature_selection':['', '--feature-selection'][featsel],
		'exclude':['', '--exclude'][exclude],
		'use_memory': memory,
		'use_chtc': ['requirements = (Target.PoolName =!= "CHTC")', '']['chtc' in pools],
		'use_osg': ['', '+wantGlidein = true']['osg' in pools],
		'use_uw': ['', '+wantFlocking = true']['uw' in pools],
	})

	run(params, flags)
