FROM ubuntu:16.04
MAINTAINER Jakob Jarosch <dev@jakobjarosch.de>

RUN echo "postfix postfix/mailname string local.cloud" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

RUN apt-get update && apt-get install -y postfix postfix-mysql
RUN apt-get update && apt-get install -y dovecot-imapd dovecot-pop3d dovecot-mysql
RUN apt-get update && apt-get install -y amavis clamav clamav-daemon spamassassin
RUN apt-get update && apt-get install -y supervisor
RUN apt-get update && apt-get install -y mysql-client

COPY scripts /scripts
RUN chmod -R +x ./scripts/*.sh

COPY config/supervisor.conf /supervisor.conf

COPY config-templates/postfix /etc/postfix
COPY config-templates/clamav /etc/clamav

# SMTP & Secure SMTP
EXPOSE 25  587

# IMAP & Secure IMAP
EXPOSE 143 993

# POP3 & Secure POP3
EXPOSE 110 995

ENV MYSQL_HOST=mysql
ENV MYSQL_USER=root
ENV MYSQL_PASS=root
ENV MYSQL_DB=mail

ENV MAIL_HOST=mail.mydomain.tld

ENTRYPOINT ["/scripts/entrypoint.sh"]
