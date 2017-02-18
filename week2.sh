#!/bin/bash
# Copyright (C) 2017 HackYourFuture
# 
# Truncates and repopulates sample data for week one
HYF_CONFIG=hyf.cnf
MYSQL_OPTIONS="--defaults-extra-file=${HYF_CONFIG} --table"

# Load the week one data
echo
echo "Loading week one data"
echo
mysql ${MYSQL_OPTIONS} < week2data.sql
echo
