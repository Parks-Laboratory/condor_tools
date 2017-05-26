#!/usr/bin/env python
from pprint import pprint

if __name__ == '__main__':
	from argparse import ArgumentParser
	
	parser = ArgumentParser()

	parser.add_argument('dataset', help='dataset to run', action='store')
	parser.add_argument('process_id', help= 'phenotype index', action='store')
	parser.add_argument('--debug', dest='debug', help='log debugging output',
	default=False, action='store_true')

	args = parser.parse_args()

	debug = args.debug
	dataset = args.dataset
	process_id = int( args.process_id )

	output_dir = root

	if debug:
		print('args:')
		pprint(args)
