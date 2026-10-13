/*
================================================================================
檔案代號:lns_file
檔案名稱:付款方式优惠减免信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lns_file
(
lns01       varchar2(10),            /*no use 原门店编号                      */
lns02       varchar2(10) DEFAULT ' ' NOT NULL, /*付款方式编号*/
lns03       varchar2(10),            /*费用明细编码                           */
lns04       number(6,2),             /*折扣率                                 */
lns05       number(10),              /*减免月数                               */
lns06       varchar2(1),             /*有效否                                 */
lnslegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnsstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lns_file add  constraint lns_pk primary key  (lnsstore,lns02) enable validate;
grant select on lns_file to tiptopgp;
grant update on lns_file to tiptopgp;
grant delete on lns_file to tiptopgp;
grant insert on lns_file to tiptopgp;
grant index on lns_file to public;
grant select on lns_file to ods;
