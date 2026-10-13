/*
================================================================================
檔案代號:ljb_file
檔案名稱:优惠单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljb_file
(
ljb01       varchar2(20) DEFAULT ' ' NOT NULL, /*申请单号*/
ljb02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljb03       varchar2(1) DEFAULT ' ' NOT NULL, /*优惠类型*/
ljb04       varchar2(10),            /*费用编号                               */
ljb05       date,                    /*优惠开始日期                           */
ljb06       date,                    /*优惠结束日期                           */
ljb07       number(20,6),            /*优惠金额                               */
ljb08       varchar2(60),            /*优惠原因                               */
ljblegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljbplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ljb_file add  constraint ljb_pk primary key  (ljb01,ljb02) enable validate;
grant select on ljb_file to tiptopgp;
grant update on ljb_file to tiptopgp;
grant delete on ljb_file to tiptopgp;
grant insert on ljb_file to tiptopgp;
grant index on ljb_file to public;
grant select on ljb_file to ods;
