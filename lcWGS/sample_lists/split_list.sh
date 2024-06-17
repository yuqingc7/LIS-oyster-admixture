#!/bin/bash

# this script split the *_list file by 10 lines
split -dl 10 --suffix-length=1 --numeric-suffixes=1 --additional-suffix=.txt bam_list.txt bam_list_
