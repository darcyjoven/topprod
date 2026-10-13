/*
================================================================================
檔案代號:lmx_file
檔案名稱:费用设置摊位选择档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table lmx_file
(
lmx01       varchar2(10) DEFAULT ' ' NOT NULL, /*费用明细编号*/
lmx02       varchar2(10),            /*no use 原门店编号                      */
lmx03       varchar2(10) DEFAULT ' ' NOT NULL, /*楼栋编号*/
lmx04       varchar2(10) DEFAULT ' ' NOT NULL, /*楼层编号*/
lmx05       varchar2(10) DEFAULT ' ' NOT NULL, /*小类编号*/
lmx06       varchar2(4) DEFAULT ' ' NOT NULL, /*年份*/
lmx07       varchar2(2) DEFAULT ' ' NOT NULL, /*月份*/
lmx08       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位编号*/
lmx09       number(20,2),            /*费用标准                               */
lmx10       number(10),              /*人数                                   */
lmx11       number(20,2),            /*费用合计                               */
lmxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lmxstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lmx_file add  constraint lmx_pk primary key  (lmx01,lmxstore,lmx03,lmx04,lmx05,lmx06,lmx07,lmx08) enable validate;
grant select on lmx_file to tiptopgp;
grant update on lmx_file to tiptopgp;
grant delete on lmx_file to tiptopgp;
grant insert on lmx_file to tiptopgp;
grant index on lmx_file to public;
grant select on lmx_file to ods;
