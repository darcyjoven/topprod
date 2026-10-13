/*
================================================================================
檔案代號:ljf_file
檔案名稱:商户退场条款资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljf_file
(
ljf01       varchar2(20) DEFAULT ' ' NOT NULL, /*退场单号*/
ljf02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljf03       varchar2(10),            /*费用编号                               */
ljf04       varchar2(20),            /*标准优惠方案                           */
ljf05       varchar2(1) DEFAULT ' ' NOT NULL, /*数据类型*/
ljf06       varchar2(1) DEFAULT ' ' NOT NULL, /*费用退优惠不回收*/
ljflegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljfplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ljf_file add  constraint ljf_pk primary key  (ljf01,ljf02) enable validate;
grant select on ljf_file to tiptopgp;
grant update on ljf_file to tiptopgp;
grant delete on ljf_file to tiptopgp;
grant insert on ljf_file to tiptopgp;
grant index on ljf_file to public;
grant select on ljf_file to ods;
