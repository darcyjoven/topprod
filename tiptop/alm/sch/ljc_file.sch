/*
================================================================================
檔案代號:ljc_file
檔案名稱:优惠情况单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljc_file
(
ljc01       varchar2(20) DEFAULT ' ' NOT NULL, /*申请单号*/
ljc02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljc03       varchar2(1) DEFAULT ' ' NOT NULL, /*执行类型*/
ljc04       varchar2(20),            /*来源单号                               */
ljc05       number(5),               /*来源单号项次                           */
ljc06       varchar2(10),            /*费用编号                               */
ljc07       date,                    /*优惠开始日期                           */
ljc08       date,                    /*优惠结束日期                           */
ljc09       number(20,6),            /*优惠金额                               */
ljc10       varchar2(60),            /*优惠原因                               */
ljclegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljcplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ljc_file add  constraint ljc_pk primary key  (ljc01,ljc02) enable validate;
grant select on ljc_file to tiptopgp;
grant update on ljc_file to tiptopgp;
grant delete on ljc_file to tiptopgp;
grant insert on ljc_file to tiptopgp;
grant index on ljc_file to public;
grant select on ljc_file to ods;
