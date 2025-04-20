#!/bin/bash

echo "Running ~/.bash_aliases"

if terraform version ; then
  alias ta="terraform apply"
  alias td="terraform destroy"
  alias tf="terraform"
  echo "Terraform aliases applied"
fi

alias activate="source ./.venv/bin/activate"
alias venv=activate

