/*
================================================================================
檔案代號:axss_file
檔案名稱:来源科目misc明细科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axss_file
(
axss00      varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
axss01      varchar2(24) DEFAULT ' ' NOT NULL, /*来源：母(子)公司科目编号*/
axss03      varchar2(24) DEFAULT ' ' NOT NULL /*来源：母(子)公司科目misc明细 */
);

alter table axss_file add  constraint axss_pk primary key  (axss00,axss01,axss03) enable validate;
grant select on axss_file to tiptopgp;
grant update on axss_file to tiptopgp;
grant delete on axss_file to tiptopgp;
grant insert on axss_file to tiptopgp;
grant index on axss_file to public;
grant select on axss_file to ods;
