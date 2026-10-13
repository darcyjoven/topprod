/*
================================================================================
檔案代號:nca_file
檔案名稱:通知tabletxt格式字段设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nca_file
(
nca01       varchar2(10) DEFAULT ' ' NOT NULL, /*网络银行接口银行编码*/
nca02       varchar2(10) DEFAULT ' ' NOT NULL, /*TIPTOP登录帐号*/
nca03       number(5) DEFAULT '0' NOT NULL, /*字段序号*/
nca04       varchar2(80) DEFAULT ' ' NOT NULL /*资料来源*/
);

alter table nca_file add  constraint nca_pk primary key  (nca01,nca02,nca03) enable validate;
grant select on nca_file to tiptopgp;
grant update on nca_file to tiptopgp;
grant delete on nca_file to tiptopgp;
grant insert on nca_file to tiptopgp;
grant index on nca_file to public;
grant select on nca_file to ods;
