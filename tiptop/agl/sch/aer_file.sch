/*
================================================================================
檔案代號:aer_file
檔案名稱:合并流量表直接法存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aer_file
(
aer01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
aer02       varchar2(10) DEFAULT ' ' NOT NULL, /*最上层公司编号*/
aer03       number(5) DEFAULT '0' NOT NULL, /*年度*/
aer04       number(5) DEFAULT '0' NOT NULL, /*期别*/
aer05       varchar2(4) DEFAULT ' ' NOT NULL, /*现金变动码*/
aer06       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
aer07       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
aerlegal    varchar2(10)             /*所属法人                               */
);

alter table aer_file add  constraint aer_pk primary key  (aer01,aer02,aer03,aer04,aer05) enable validate;
grant select on aer_file to tiptopgp;
grant update on aer_file to tiptopgp;
grant delete on aer_file to tiptopgp;
grant insert on aer_file to tiptopgp;
grant index on aer_file to public;
grant select on aer_file to ods;
