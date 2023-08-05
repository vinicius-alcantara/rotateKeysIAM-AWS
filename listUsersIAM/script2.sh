#!/bin/bash
AWS_PROFILE="default";


for LIST_USER in $(aws iam list-users --profile "$AWS_PROFILE" | egrep -i "UserName" | cut -d ":" -f2 | tr -d '", ');
do
    ACCESS_KEY=$(aws iam list-access-keys --user-name $LIST_USER --profile "$AWS_PROFILE" --query 'AccessKeyMetadata[*].AccessKeyId' --output text)
    if [ -z "$ACCESS_KEY" ]; then
       echo "$LIST_USER - Não possui chaves de acesso." >> no_access_keys_user.txt;
    else
       echo "$LIST_USER - Possui a seguinte chave de acesso: $ACCESS_KEY" >> users_with_access_keys.txt;
    fi
done
