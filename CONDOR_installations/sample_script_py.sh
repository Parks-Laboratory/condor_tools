#!/bin/bash

# untar your Python installation
tar -xzvf python.tar.gz

# make sure the script will use your Python installation
export PATH=$(pwd)/python/bin:$PATH

# run your script
python my_script.py
