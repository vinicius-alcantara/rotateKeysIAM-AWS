#!/bin/bash

AWS_PROFILE="default";
TAG_NAME="SERVICE_ACCOUNT";
TAG_VALUE="false";
USER_LIST_NAME="list-users-VINICIUS.txt";

function create_tag_user(){
for USER in $(cat "$USER_LIST_NAME");
do

  aws iam tag-user --user-name $USER --tags Key="$TAG_NAME",Value="$TAG_VALUE" --profile "$AWS_PROFILE";

done
}

create_tag_user;
