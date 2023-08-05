#!/bin/bash

source $(pwd)/_vars.sh;
source $(pwd)/_functions.sh;
source $(pwd)/_sendMail.sh;

main(){
for USER_NAME in $(list_users);
do
     QTD_ACCESS_KEY=$(qtd_access_keys);
     USER_TAG=$(user_tag_filter);
     if [ "$USER_TAG" == "false" ] && [ "$QTD_ACCESS_KEY" -eq 1 ];
     then
        
	USER_EMAIL_GMAIL="$USER_NAME$GMAIL_DOMAIN_EMAIL"; 
	CURRENT_ACCESS_KEY_ID=$(current_access_key_id_filter);
	KEY_STATUS=$(get_key_status);
	SECRET_KEY_CREATED_DATE=$(secret_key_created_date_filter);
	SECRET_KEY_CREATED_DATE_TIMESTAMP_CONVERTED=$(convert_to_timestamp "$SECRET_KEY_CREATED_DATE");
	CURRENT_DATE_TIMESTAMP_CONVERTED=$(convert_to_timestamp "$CURRENT_DATE");
	DIFFERENCE=$(("$CURRENT_DATE_TIMESTAMP_CONVERTED" - "$SECRET_KEY_CREATED_DATE_TIMESTAMP_CONVERTED"));
	DIFFERENCE_IN_DAYS=$(echo "scale=0; $DIFFERENCE / (24 * 60 * 60)" | bc);

	if [ "$DIFFERENCE_IN_DAYS" -ge "$THRESHOLD_MAX_DAYS" ] && [ "$KEY_STATUS" == "Active" ];
	then
	    echo "O usuário $USER_NAME possui uma única access key $CURRENT_ACCESS_KEY_ID com idade maior ou igual a $DIFFERENCE_IN_DAYS dias e será rotacionada!"; #DEBUG
	    deactivate_old_keys;
	    configure_date_schedule;
	    delete_old_keys_schedule;
            MAIL_TO="$USER_EMAIL_GMAIL";
            create_body_mail;
            sed -i s/current_access_key_id/$CURRENT_ACCESS_KEY_ID/g $REPORT;
            send_email;
	fi
     fi

     if [ "$USER_TAG" == "false" ] && [ "$QTD_ACCESS_KEY" -eq 2 ];
     then

	  USER_EMAIL_GMAIL="$USER_NAME$GMAIL_DOMAIN_EMAIL";
	  CURRENT_ACCESS_KEY1_ID=$(current_access_key_id_filter | head -n1);
	  KEY1_STATUS=$(get_key_status);
	  CURRENT_ACCESS_KEY2_ID=$(current_access_key_id_filter | tail -n1);
	  KEY2_STATUS=$(get_key_status);
	  SECRET_KEY1_CREATED_DATE=$(secret_key_created_date_filter | head -n1);
	  SECRET_KEY2_CREATED_DATE=$(secret_key_created_date_filter | tail -n1);
	  SECRET_KEY1_CREATED_DATE_TIMESTAMP_CONVERTED=$(convert_to_timestamp "$SECRET_KEY1_CREATED_DATE");
	  SECRET_KEY2_CREATED_DATE_TIMESTAMP_CONVERTED=$(convert_to_timestamp "$SECRET_KEY2_CREATED_DATE");
	  CURRENT_DATE_TIMESTAMP_CONVERTED=$(convert_to_timestamp "$CURRENT_DATE");
	  DIFFERENCE_KEY1=$(("$CURRENT_DATE_TIMESTAMP_CONVERTED" - "$SECRET_KEY1_CREATED_DATE_TIMESTAMP_CONVERTED"));
	  DIFFERENCE_KEY2=$(("$CURRENT_DATE_TIMESTAMP_CONVERTED" - "$SECRET_KEY2_CREATED_DATE_TIMESTAMP_CONVERTED"));
	  DIFFERENCE_IN_DAYS_KEY1=$(echo "scale=0; $DIFFERENCE_KEY1 / (24 * 60 * 60)" | bc);
	  DIFFERENCE_IN_DAYS_KEY2=$(echo "scale=0; $DIFFERENCE_KEY2 / (24 * 60 * 60)" | bc);

	if [ "$DIFFERENCE_IN_DAYS_KEY1" -ge "$THRESHOLD_MAX_DAYS" ] && [ "$KEY1_STATUS" == "Active" ];
	then
	    echo "O usuário $USER_NAME possui a access key1 $CURRENT_ACCESS_KEY1_ID com idade maior ou igual a $DIFFERENCE_IN_DAYS_KEY1 dias e será rotacionada!";
	    deactivate_old_if_2keys;
	    configure_date_schedule;
	    delete_old_keys_schedule_first_key;
	    MAIL_TO="$USER_EMAIL_GMAIL";
            create_body_mail;
	    sed -i s/current_access_key_id/$CURRENT_ACCESS_KEY1_ID/g $REPORT;
            send_email;
	fi

	if [ "$DIFFERENCE_IN_DAYS_KEY2" -ge "$THRESHOLD_MAX_DAYS" ] && [ "$KEY2_STATUS" == "Active" ];
        then
	    echo "O usuário $USER_NAME possui a access key2 $CURRENT_ACCESS_KEY2_ID com idade maior ou igual a $DIFFERENCE_IN_DAYS_KEY2 dias e será rotacionada!";
            deactivate_old_if_2keys;
	    configure_date_schedule;
            delete_old_keys_schedule_second_key;
            MAIL_TO="$USER_EMAIL_GMAIL";
            create_body_mail;
            sed -i s/current_access_key_id/$CURRENT_ACCESS_KEY2_ID/g $REPORT;
            send_email;
	fi
     fi
done
}

main;
