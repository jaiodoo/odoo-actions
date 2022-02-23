#!/bin/bash

# --- ARGUMENTOS --- #
# $1: python-root
# $2: flake8-flags
# $3: skip-flake8


cd "$1"
submodules=$(git submodule foreach --quiet 'echo $sm_path')
myarray=($submodules)

for dir in $(ls -1)
 do
  if printf '%s\n' "${myarray[@]}" | grep -Fxq "$dir";
   then
    continue
  fi
 if [[ $dir == *"."* ]]
   then
    continue
  fi
  if [[ $dir == *".orig" ]]
   then
    continue
  fi
  if [[ $dir == *".md" ]]
   then
    continue
  fi
  if [[ $dir == *".rst" ]]
   then
    continue
  fi
  # Pylint-odoo
  PYLINT_ERRORS+=$(python3 -m pylint --rcfile=/.pylintrc  --load-plugins=pylint_odoo $2 "$dir")
  exit_code=$?
  
  # Flake8
  if [ "$3" = '' ]; then
    FLAKE8_ERRORS+=$(python3 -m flake8 $2 "$dir")
    if [ "$exit_code" != "0" ]; then
      exit_code=$exit_code
    else
      exit_code=$?
    fi
  fi
done

if [ "$exit_code" != "0" ]; then
  printf "\ flake8 errors:\n-----------------\n%s\n-----------------\n" "$FLAKE8_ERRORS"
  printf "\ pylint errors:\n-----------------\n%s\n-----------------\n" "$PYLINT_ERRORS"
  exit $exit_code
fi
