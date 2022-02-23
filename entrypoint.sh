#!/bin/bash

# --- ARGUMENTOS --- #
# $1: python-root
# $2: flake8-flags
# $3: skip-flake8

cd "$1"
for dir in $(ls -1)
 do
  if [[ $dir == *"."* ]]
   then
    continue
  fi
   PYLINT_ERRORS+=$(python3 -m pylint --rcfile=/.pylintrc --load-plugins=pylint_odoo -d all -e odoolint "$dir")
   exit_code=$?
done
if [ "$exit_code" != "0" ]; then
      printf "\npylint-odoo errors:\n-----------------\n%s\n-----------------\n" "$PYLINT_ERRORS"
      exit $exit_code
    fi

if [ "$5" = false ]; then
  FLAKE8_ERRORS=$(python3 -m flake8 $2 "$1")
  exit_code=$?

  if [ "$exit_code" != "0" ]; then
    printf "\nflake8 errors:\n-----------------\n%s\n-----------------\n" "$FLAKE8_ERRORS"
    exit $exit_code
  fi
fi
