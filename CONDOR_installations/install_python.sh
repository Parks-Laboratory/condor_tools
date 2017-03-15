#!/bin/bash

mkdir python
tar -xzvf Python-2.7.12.tgz

cd Python-2.7.12
./configure --prefix=$(pwd)/../python
make
make install

cd ..

cp python/bin/python2 python/bin/python

# install modules
export PATH=$(pwd)/python/bin:$PATH
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install numpy
pip install scipy
pip install matplotlib
pip install pandas
pip install scikit-learn
pip install cython
pip install pysnptools
pip install statsmodels
pip install fastlmm

tar -czvf python.tar.gz python/
exit
