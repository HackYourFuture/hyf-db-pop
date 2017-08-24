FROM mysql

COPY populate.sh /populate.sh
COPY *.sql /

