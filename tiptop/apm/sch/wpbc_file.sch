/*
================================================================================
檔案代號:wpbc_file
檔案名稱:预测采购需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wpbc_file
(
wpbc01      varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
wpbc02      date DEFAULT sysdate NOT NULL, /*预计需求日期*/
wpbc03      varchar2(10) DEFAULT ' ' NOT NULL /*厂商编号*/
);

alter table wpbc_file add  constraint wpbc_pk primary key  (wpbc01,wpbc02,wpbc03) enable validate;
grant select on wpbc_file to tiptopgp;
grant update on wpbc_file to tiptopgp;
grant delete on wpbc_file to tiptopgp;
grant insert on wpbc_file to tiptopgp;
grant index on wpbc_file to public;
grant select on wpbc_file to ods;
