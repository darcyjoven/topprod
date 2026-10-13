/*
================================================================================
檔案代號:lsw_file
檔案名稱:换券变更设定单身二档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsw_file
(
lsw01       varchar2(20) DEFAULT ' ' NOT NULL, /*兑换方案代码*/
lsw02       varchar2(20) DEFAULT ' ' NOT NULL, /*券种编号*/
lsw03       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lsw04       number(5) DEFAULT '0' NOT NULL, /*兑换方案版本号*/
lswlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lswplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lsw00       varchar2(1) DEFAULT ' ' NOT NULL, /*兑换来源*/
                                     /*0.积分换券, 1.累计消费额换券           */
lsw05       varchar2(20) DEFAULT ' ' NOT NULL /*卡种代号*/
);

alter table lsw_file add  constraint lsw_pk primary key  (lsw00,lsw01,lsw02,lsw03,lsw04,lsw05,lswplant) enable validate;
grant select on lsw_file to tiptopgp;
grant update on lsw_file to tiptopgp;
grant delete on lsw_file to tiptopgp;
grant insert on lsw_file to tiptopgp;
grant index on lsw_file to public;
grant select on lsw_file to ods;
