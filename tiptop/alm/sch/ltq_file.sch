/*
================================================================================
檔案代號:ltq_file
檔案名稱:设置收券规则单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ltq_file
(
ltq01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定營運中心*/
ltq02       varchar2(20) DEFAULT ' ' NOT NULL, /*规格单号*/
ltq03       varchar2(40) DEFAULT ' ' NOT NULL, /*编号*/
ltqacti     varchar2(1) DEFAULT ' ' NOT NULL, /*有效码*/
ltqlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ltqplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table ltq_file add  constraint ltq_pk primary key  (ltq01,ltq02,ltq03,ltqplant) enable validate;
grant select on ltq_file to tiptopgp;
grant update on ltq_file to tiptopgp;
grant delete on ltq_file to tiptopgp;
grant insert on ltq_file to tiptopgp;
grant index on ltq_file to public;
grant select on ltq_file to ods;
