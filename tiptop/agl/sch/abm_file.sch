/*
================================================================================
檔案代號:abm_file
檔案名稱:帐别传票抛转记录文件
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table abm_file
(
abm01       varchar2(10) DEFAULT ' ' NOT NULL, /*抛转来源营运中心*/
abm02       varchar2(5) DEFAULT ' ' NOT NULL, /*抛转来源帐别*/
abm03       varchar2(20) DEFAULT ' ' NOT NULL, /*抛转来源传票编号*/
abm04       varchar2(10) DEFAULT ' ' NOT NULL, /*抛转目的营运中心*/
abm05       varchar2(5) DEFAULT ' ' NOT NULL, /*抛转目的帐别*/
abm06       varchar2(20) DEFAULT ' ' NOT NULL, /*抛转目的传票编号*/
abm07       date DEFAULT sysdate NOT NULL, /*抛转日期*/
abm08       varchar2(8) DEFAULT ' ' NOT NULL, /*抛转时间*/
abm09       varchar2(10) DEFAULT ' ' NOT NULL /*抛转人员代号*/
);

alter table abm_file add  constraint abm_pk primary key  (abm01,abm02,abm03,abm04,abm05,abm06,abm07,abm08,abm09) enable validate;
grant select on abm_file to tiptopgp;
grant update on abm_file to tiptopgp;
grant delete on abm_file to tiptopgp;
grant insert on abm_file to tiptopgp;
grant index on abm_file to public;
grant select on abm_file to ods;
