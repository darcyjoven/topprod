/*
================================================================================
檔案代號:ckb_file
檔案名稱:成本性质对应科目表
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ckb_file
(
ckb01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
ckb02       varchar2(1) DEFAULT ' ' NOT NULL, /*成本性质*/
ckb03       varchar2(24) DEFAULT ' ' NOT NULL, /*对应科目*/
ckb04       varchar2(1) DEFAULT ' ' NOT NULL /*有效否*/
);

create unique index ckb_01 on ckb_file (ckb01,ckb02,ckb03);
alter table ckb_file add  constraint ckb_pk primary key  (ckb01,ckb02,ckb03) enable validate;
grant select on ckb_file to tiptopgp;
grant update on ckb_file to tiptopgp;
grant delete on ckb_file to tiptopgp;
grant insert on ckb_file to tiptopgp;
grant index on ckb_file to public;
grant select on ckb_file to ods;
