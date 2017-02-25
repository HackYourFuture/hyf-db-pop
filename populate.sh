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
  step[1-3])
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
    echo $"Then run $0 {step1|step2|step3} to populate the database."
    echo $""
    exit 1
    ;;
  *)
    echo $""
    echo $"Usage: $0 {config|step1|step2|step3}"
    echo $""
    echo $"Actions:"
    echo $"  config: display instructions for creating the config file"
    echo $"  step1: populate the database with a single table 'todos' with three"
    echo $"    columns - 'Id', 'Done', and 'Name'"
    echo $"  step2: populate the database with a single table 'todos' with five"
    echo $"    columns - 'Id', 'Done', 'Name', 'Status', and 'Due'"
    echo $"  step3: populate the database with two related tables 'todos' and"
    echo $"    'statuses'. Removes column 'Done' and replaces 'Status' with"
    echo $"    'StatusId' in table 'todos'. Table 'statuses' has two columns - "
    echo $"    'Id' and 'Name'. Adds foreign key constraint to table 'todos'."
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
