/*
================================================================================
檔案代號:lva_file
檔案名稱:邮政编码资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lva_file
(
lva01       varchar2(10) DEFAULT ' ' NOT NULL, /*邮递区号*/
lva02       varchar2(20) DEFAULT ' ' NOT NULL,
lva03       varchar2(20) DEFAULT ' ' NOT NULL,
lva04       varchar2(100) DEFAULT ' ' NOT NULL,
lva05       varchar2(100) DEFAULT ' ' NOT NULL
);

alter table lva_file add  constraint lva_pk primary key  (lva01,lva02,lva03,lva04,lva05) enable validate;
grant select on lva_file to tiptopgp;
grant update on lva_file to tiptopgp;
grant delete on lva_file to tiptopgp;
grant insert on lva_file to tiptopgp;
grant index on lva_file to public;
grant select on lva_file to ods;
