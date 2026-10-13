/*
================================================================================
檔案代號:nnc_file
檔案名稱:银行账户汇款性质档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nnc_file
(
nnc01       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
nnc02       varchar2(10) DEFAULT ' ' NOT NULL, /*性质代码*/
nnc03       varchar2(80),            /*性质说明                               */
nnc00       varchar2(20) DEFAULT ' ' NOT NULL /*银行编号*/
);

alter table nnc_file add  constraint nnc_pk primary key  (nnc00,nnc01,nnc02) enable validate;
grant select on nnc_file to tiptopgp;
grant update on nnc_file to tiptopgp;
grant delete on nnc_file to tiptopgp;
grant insert on nnc_file to tiptopgp;
grant index on nnc_file to public;
grant select on nnc_file to ods;
