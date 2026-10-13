/*
================================================================================
檔案代號:rce_file
檔案名稱:百货公司核算资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rce_file
(
rce01       varchar2(20) DEFAULT ' ' NOT NULL, /*百货公司核算单号*/
rce02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rce03       varchar2(10),            /*抽成编号                               */
rce04       number(20,6) DEFAULT '0' NOT NULL, /*专柜未税销售金额*/
rce05       number(20,6) DEFAULT '0' NOT NULL, /*专柜含税销售金额*/
rce06       number(20,6) DEFAULT '0' NOT NULL, /*核算销售金额*/
rcelegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rceplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table rce_file add  constraint rce_pk primary key  (rce01,rce02) enable validate;
grant select on rce_file to tiptopgp;
grant update on rce_file to tiptopgp;
grant delete on rce_file to tiptopgp;
grant insert on rce_file to tiptopgp;
grant index on rce_file to public;
grant select on rce_file to ods;
