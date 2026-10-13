/*
================================================================================
檔案代號:gex_file
檔案名稱:资料中心抛转记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gex_file
(
gex01       varchar2(10) DEFAULT ' ' NOT NULL, /*资料中心代码*/
gex02       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
gex03       varchar2(10) DEFAULT ' ' NOT NULL, /*抛转营运中心*/
gex04       varchar2(20) DEFAULT ' ' NOT NULL, /*程序编号*/
gex05       varchar2(80) DEFAULT ' ' NOT NULL, /*抛转主健值*/
gex06       number(10),              /*抛转笔数                               */
gex07       date DEFAULT sysdate NOT NULL, /*抛转日期*/
gex08       varchar2(8) DEFAULT ' ' NOT NULL, /*抛转时间*/
gex09       varchar2(10) DEFAULT ' ' NOT NULL /*抛转人员代号*/
);

alter table gex_file add  constraint gex_pk primary key  (gex01,gex02,gex03,gex04,gex05,gex07,gex08,gex09) enable validate;
grant select on gex_file to tiptopgp;
grant update on gex_file to tiptopgp;
grant delete on gex_file to tiptopgp;
grant insert on gex_file to tiptopgp;
grant index on gex_file to public;
grant select on gex_file to ods;
