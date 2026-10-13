/*
================================================================================
檔案代號:ryu_file
檔案名稱:公告生效门店档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ryu_file
(
ryu01       varchar2(20) DEFAULT ' ' NOT NULL, /*公告单号*/
ryu02       varchar2(10) DEFAULT ' ' NOT NULL /*生效门店*/
);

alter table ryu_file add  constraint ryu_pk primary key  (ryu01,ryu02) enable validate;
grant select on ryu_file to tiptopgp;
grant update on ryu_file to tiptopgp;
grant delete on ryu_file to tiptopgp;
grant insert on ryu_file to tiptopgp;
grant index on ryu_file to public;
grant select on ryu_file to ods;
