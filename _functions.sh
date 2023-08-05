#!/bin/bash

source $(pwd)/_vars.sh;

function qtd_access_keys(){
  aws iam list-access-keys --user-name "$USER_NAME" --profile "$AWS_PROFILE" | jq -r '.AccessKeyMetadata[].AccessKeyId' | wc -l;
}

function list_users(){
  aws iam list-users --profile "$AWS_PROFILE" | jq -r '.Users[].UserName';
}

function user_tag_filter(){
  aws iam get-user --user-name "$USER_NAME" --profile "$AWS_PROFILE" | jq -r '.User.Tags[] | select(.Key == "SERVICE_ACCOUNT").Value';
}

function current_access_key_id_filter(){
  aws iam list-access-keys --user-name $USER_NAME --profile "$AWS_PROFILE" | jq -r '.AccessKeyMetadata[].AccessKeyId';
}

function get_key_status(){
  aws iam list-access-keys --user-name $USER_NAME --profile "$AWS_PROFILE" | jq -r '.AccessKeyMetadata[0].Status';
} 

function secret_key_created_date_filter(){
  aws iam list-access-keys --user-name $USER_NAME --profile "$AWS_PROFILE" | jq -r '.AccessKeyMetadata[].CreateDate' | cut -c1-10;
}

function convert_to_timestamp() {
  local date_str="$1";
  local timestamp=$(date -d "$date_str" +"%s");
  echo "$timestamp";
}

function create_new_keys(){
  aws iam create-access-key --user-name $USER_NAME --profile "$AWS_PROFILE" | egrep -i "SecretAccessKey|AccessKeyId" | tr -d ',';
}

function report_generate(){
  echo "User: $USER_NAME" >> $REPORT;
  echo " " >> $REPORT;
  echo "$NEW_ACCESS_KEY_AND_SECRET_KEY" >> $REPORT;
  echo " " >> $REPORT;
  echo "--------------------------------------------------------------------------------------------------" >> $REPORT;
  echo " " >> $REPORT;
}

function configure_date_schedule(){
  NEW_DATE=$(date -d "+7 days" +%m%d%y);
  HOUR_MINUTE="23:00";
  SCHEDULED_TIME="${HOUR_MINUTE} ${NEW_DATE}";
}

function deactivate_old_keys(){
  aws iam update-access-key --access-key-id "$CURRENT_ACCESS_KEY_ID" --status Inactive --user-name "$USER_NAME" --profile "$AWS_PROFILE";
}

function delete_old_keys_schedule(){
  echo "aws iam delete-access-key --access-key-id $CURRENT_ACCESS_KEY_ID --user-name $USER_NAME" --profile "$AWS_PROFILE" | at "$SCHEDULED_TIME";
}

function deactivate_old_if_2keys(){
  aws iam update-access-key --access-key-id "$CURRENT_ACCESS_KEY1_ID" --status Inactive --user-name "$USER_NAME" --profile "$AWS_PROFILE";
  aws iam update-access-key --access-key-id "$CURRENT_ACCESS_KEY2_ID" --status Inactive --user-name "$USER_NAME" --profile "$AWS_PROFILE";
}

function delete_old_keys_schedule_first_key(){
  echo "aws iam delete-access-key --access-key-id $CURRENT_ACCESS_KEY1_ID --user-name $USER_NAME" --profile "$AWS_PROFILE" | at "$SCHEDULED_TIME";
}


function delete_old_keys_schedule_second_key(){
  echo "aws iam delete-access-key --access-key-id $CURRENT_ACCESS_KEY2_ID --user-name $USER_NAME" --profile "$AWS_PROFILE" | at "$SCHEDULED_TIME";
}


