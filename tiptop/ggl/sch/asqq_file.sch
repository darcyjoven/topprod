/*
================================================================================
檔案代號:asqq_file
檔案名稱:会计科目对冲关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table asqq_file
(
asqq01      varchar2(24) DEFAULT ' ' NOT NULL, /*来源科目编号*/
asqq02      varchar2(24) DEFAULT ' ' NOT NULL, /*对冲科目编号*/
asqq03      varchar2(1) DEFAULT ' ' NOT NULL, /*依股权比率冲销*/
asqq04      varchar2(24),            /*差额对应科目                           */
asqq05      varchar2(1) DEFAULT ' ' NOT NULL, /*股本冲销*/
asqq06      varchar2(1) DEFAULT ' ' NOT NULL, /*來源公司科目餘額來源檔案*/
asqq07      varchar2(1) DEFAULT ' ' NOT NULL, /*目的公司科目餘額來源檔案*/
asqqacti    varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
asqq18      varchar2(1) DEFAULT ' ' NOT NULL /*差额处理方式*/
);

alter table asqq_file add  constraint asqq_pk primary key  (asqq01,asqq02) enable validate;
grant select on asqq_file to tiptopgp;
grant update on asqq_file to tiptopgp;
grant delete on asqq_file to tiptopgp;
grant insert on asqq_file to tiptopgp;
grant index on asqq_file to public;
grant select on asqq_file to ods;
