#!/bin/bash

# --- ARGUMENTOS --- #
# $1: python-root
# $2: flake8-flags
# $3: skip-flake8
# $4: skip-black

cd "$1"
for dir in $(ls -1)
 do
  if [[ $dir == *"."* ]]
   then
    continue
  fi
   PYLINT_ERRORS+=$(python3 -m pylint --rcfile=/.pylintrc --load-plugins=pylint_odoo $2  "$dir")
   exit_code=$?
done
if [ "$exit_code" != "0" ]; then
  printf "\npylint-odoo errors:\n-----------------\n%s\n-----------------\n" "$PYLINT_ERRORS"
  exit $exit_code
fi

if [ "$3" = '' ]; then
  FLAKE8_ERRORS=$(python3 -m flake8 $2 "$1")
  exit_code=$?

  if [ "$exit_code" != "0" ]; then
    printf "\nflake8 errors:\n-----------------\n%s\n-----------------\n" "$FLAKE8_ERRORS"
    exit $exit_code
  fi
fi

if [ "$4" = '' ]; then
  BLACK_ERRORS=$(python3 -m black --line-length 80 "$1" --check)
  exit_code=$?

  if [ "$exit_code" != "0" ]; then
    printf "\black errors:\n-----------------\n%s\n-----------------\n" "$BLACK_ERRORS"
    exit $exit_code
  fi
fi
