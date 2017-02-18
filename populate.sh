#!/bin/bash
# Copyright (C) 2017 HackYourFuture
# 
# Truncates and repopulates sample data for a given week.

# The below config file should NOT be stored in git.
#
# All parameters are optional, but if not included must be specified on the
# command line or the defaults are used where applicable.
HYF_CONFIG=hyf.cnf

# Check command line arguments for which week to populate.
case $1 in
  week[1-2])
    SQL_FILE=$1data.sql
    ;;
  config)
    echo $""
    echo $"Create ${HYF_CONFIG} in the working directory with the following format:"
    echo $""
    echo $"[client]"
    echo $"user=\${username}"
    echo $"password=\${password}"
    echo $"host=\${host}"
    echo $"port=\${port}"
    echo $"database=\${database}"
    echo $""
    echo $"Then run $0 {week1|week2} to populate the database."
    echo $""
    exit 1  
    ;;
  *)
    echo $""
    echo $"Usage: $0 {config|week1|week2}"
    echo $""
    echo $"Actions:"
    echo $"  config: display instructions for creating the config file"
    echo $"  week1: populate the database with week one data"
    echo $"  week2: populate the database with week two data"
    echo $""
    exit 1
esac

# Check for existence of the script file.
if [[ ! -f ${SQL_FILE} ]]; then
  echo $"SQL script file ${SQL_FILE} not found"
  exit 1
fi

# Check that the config file exists.
if [[ ! -f ${HYF_CONFIG} ]]; then
  echo $"Configuration file ${HYF_CONFIG} not found."
  echo $"Run $0 config for instructions."
  echo $""
  exit 1
fi

MYSQL_OPTIONS="--defaults-extra-file=${HYF_CONFIG} --table"

# Load the requested data
echo
echo "Loading $1 data"
echo
mysql ${MYSQL_OPTIONS} < ${SQL_FILE}
echo