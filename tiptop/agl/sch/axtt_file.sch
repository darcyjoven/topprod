/*
================================================================================
檔案代號:axtt_file
檔案名稱:对冲科目mis明细科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axtt_file
(
axtt00      varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
axtt01      varchar2(24) DEFAULT ' ' NOT NULL, /*对冲：子公司科目编号*/
axtt03      varchar2(24) DEFAULT ' ' NOT NULL, /*对冲：子公司科目misc明细科目*/
axtt04      varchar2(1) DEFAULT ' ' NOT NULL, /*是否依公式設置*/
axtt05      varchar2(1) DEFAULT ' ' NOT NULL, /*是否依股权冲销*/
axtt06      varchar2(1) DEFAULT ' ' NOT NULL /*少数股权否*/
);

alter table axtt_file add  constraint axtt_pk primary key  (axtt00,axtt01,axtt03) enable validate;
grant select on axtt_file to tiptopgp;
grant update on axtt_file to tiptopgp;
grant delete on axtt_file to tiptopgp;
grant insert on axtt_file to tiptopgp;
grant index on axtt_file to public;
grant select on axtt_file to ods;
