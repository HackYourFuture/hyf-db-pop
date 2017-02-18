#!/bin/bash
# Copyright (C) 2017 HackYourFuture
# 
# Truncates and repopulates sample data for a given week.
#
# Check command line arguments for which week to populate.
case $1 in
  week[1-2])
    SQL_FILE=$1data.sql
    ;;
  *)
    echo $"Usage: $0 {week1|week2}"
    exit 1
esac

# Check for existence of the script file.
if [[ ! -f ${SQL_FILE} ]]; then
  echo $"SQL script file ${SQL_FILE} not found"
  exit 1
fi

# The below config file should NOT be stored in git.
#
# All parameters are optional, but if not included must be specified on the
# command line or the defaults are used where applicable.
HYF_CONFIG=hyf.cnf

# Check that the config file exists.
if [[ ! -f ${HYF_CONFIG} ]]; then
  echo $"Configuration file ${HYF_CONFIG} not found"
  echo $"Create ${HYF_CONFIG} and populate it as follows:"
  echo $""
  echo $"[client]"
  echo $"user=\${username}"
  echo $"password=\${password}"
  echo $"host=\${host}"
  echo $"port=\${port}"
  echo $"database=\${database}"
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