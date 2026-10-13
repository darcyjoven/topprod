/*
================================================================================
檔案代號:lsv_file
檔案名稱:换券变更设定单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsv_file
(
lsv01       varchar2(20) DEFAULT ' ' NOT NULL, /*兑换方案代码*/
lsv02       number(20) DEFAULT '0' NOT NULL, /*积分达*/
lsv03       number(20) DEFAULT '0' NOT NULL, /*累计消费达*/
lsv04       number(20) DEFAULT '0' NOT NULL, /*兑换基数*/
lsv05       number(20) DEFAULT '0' NOT NULL, /*兑换基数换券金额*/
lsv06       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lsv07       number(5) DEFAULT '0' NOT NULL, /*兑换方案版本号*/
lsvlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lsvplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lsv00       varchar2(1) DEFAULT ' ' NOT NULL, /*兑换来源*/
                                     /*0.积分换券, 1.累计消费额换券           */
lsv08       varchar2(20) DEFAULT ' ' NOT NULL /*卡种代号*/
);

alter table lsv_file add  constraint lsv_pk primary key  (lsv00,lsv01,lsv02,lsv03,lsv06,lsv07,lsv08,lsvplant) enable validate;
grant select on lsv_file to tiptopgp;
grant update on lsv_file to tiptopgp;
grant delete on lsv_file to tiptopgp;
grant insert on lsv_file to tiptopgp;
grant index on lsv_file to public;
grant select on lsv_file to ods;
