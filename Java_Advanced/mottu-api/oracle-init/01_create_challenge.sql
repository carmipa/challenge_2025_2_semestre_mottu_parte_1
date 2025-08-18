-- Executado como SYS pelo entrypoint
ALTER SESSION SET CONTAINER = challenge;  -- se usar XE com XEPDB1, troque aqui

CREATE USER challenge IDENTIFIED BY "2937" ACCOUNT UNLOCK;
GRANT CONNECT, RESOURCE TO challenge;
GRANT UNLIMITED TABLESPACE TO challenge;
