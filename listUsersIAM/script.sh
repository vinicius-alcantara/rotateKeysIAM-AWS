#!/bin/bash

AWS_PROFILE="default";
CLIENTE_NAME="VINICIUS";

function list_users_create(){
  aws iam list-users --profile "$AWS_PROFILE" | egrep -i "UserName" | cut -d ":" -f2 | tr -d '", ' >> list-users-"$CLIENTE_NAME".txt;
}

list_users_create;
