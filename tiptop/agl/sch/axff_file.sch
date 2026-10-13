/*
================================================================================
檔案代號:axff_file
檔案名稱:会计科目对冲关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axff_file
(
axff01      varchar2(24) DEFAULT ' ' NOT NULL, /*来源科目编号*/
axff02      varchar2(24) DEFAULT ' ' NOT NULL, /*对冲科目编号*/
axff03      varchar2(1) DEFAULT ' ' NOT NULL, /*依股权比率冲销*/
axff04      varchar2(24),            /*差额对应科目                           */
axff05      varchar2(1) DEFAULT ' ' NOT NULL, /*股本冲销*/
axff06      varchar2(1) DEFAULT ' ' NOT NULL, /*來源公司科目餘額來源檔案*/
axff07      varchar2(1) DEFAULT ' ' NOT NULL, /*目的公司科目餘額來源檔案*/
axffacti    varchar2(1) DEFAULT ' ' NOT NULL /*资料有效码*/
);

alter table axff_file add  constraint axff_pk primary key  (axff01,axff02) enable validate;
grant select on axff_file to tiptopgp;
grant update on axff_file to tiptopgp;
grant delete on axff_file to tiptopgp;
grant insert on axff_file to tiptopgp;
grant index on axff_file to public;
grant select on axff_file to ods;
