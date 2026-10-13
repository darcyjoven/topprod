/*
================================================================================
檔案代號:xsb_file
檔案名稱:订单底稿单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xsb_file
(
xsb01       varchar2(20) DEFAULT ' ' NOT NULL, /*底稿单号*/
xsb02       date,                    /*底稿日期                               */
xsb03       varchar2(20),            /*订购单号                               */
xsb04       date,                    /*订购日期                               */
xsb05       varchar2(10),            /*组织(客户)                             */
xsb06       varchar2(10),            /*送货地址码                             */
xsb07       varchar2(1) DEFAULT ' ' NOT NULL, /*状态*/
xsb08       varchar2(4),             /*税种                                   */
xsb09       number(9,4),             /*税率                                   */
xsb10       varchar2(1) DEFAULT ' ' NOT NULL, /*含税否*/
xsb11       varchar2(4),             /*币种                                   */
xsb12       varchar2(10),            /*价格条件                               */
xsb13       varchar2(20),            /*订单单号                               */
xsb99       varchar2(10) DEFAULT ' ' NOT NULL /*经销商*/
);

alter table xsb_file add  constraint xsb_pk primary key  (xsb01) enable validate;
grant select on xsb_file to tiptopgp;
grant update on xsb_file to tiptopgp;
grant delete on xsb_file to tiptopgp;
grant insert on xsb_file to tiptopgp;
grant index on xsb_file to public;
grant select on xsb_file to ods;
