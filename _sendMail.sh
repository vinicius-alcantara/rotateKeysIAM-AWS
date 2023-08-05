#!/bin/bash
######## VARs ########
source $(pwd)/_vars.sh;
SMTP_SRV="smtp.office365.com";
SMTP_PORT="587";
SMTP_USR="$(echo -ne "<email-remetente-em-base64>" | base64 -d)";
SMTP_PASS="$(echo -ne "<password-em-base64>" | base64 -d)";
MAIL_FROM="$(echo -ne "<email-remetente-em-base64>" | base64 -d)";
SUBJECT="ATENÇÃO: ROTACIONAMENTO DE CHAVE AWS";

BODY_MAIL="
From: "$MAIL_FROM"
To: "$MAIL_TO"
Subject: "$SUBJECT"

Olá,

Foi identificado que sua chave current_access_key_id tem idade maior ou igual a 90 dias. Sua chave foi inativada e será excluída permanentemente em até 7 dias.

";

function create_body_mail() {
	echo "$BODY_MAIL" | sed 1d > "$REPORT";
}

#create_body_mail;

function send_email() {
  curl --ssl-reqd \
    --url "$SMTP_SRV":"$SMTP_PORT" \
    --user "$SMTP_USR":"$SMTP_PASS" \
    --mail-from "$MAIL_FROM" \
    --mail-rcpt "$MAIL_TO" \
    --upload-file "$REPORT";
}

#send_email;
