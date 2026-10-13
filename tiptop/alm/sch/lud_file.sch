/*
================================================================================
檔案代號:lud_file
檔案名稱:费用退款单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lud_file
(
lud01       varchar2(20) DEFAULT ' ' NOT NULL, /*费用退款单号*/
lud02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lud03       varchar2(20),            /*来源单号                               */
lud04       number(5),               /*来源项次                               */
lud05       varchar2(10),            /*费用编号                               */
lud06       varchar2(20),            /*帐款编号                               */
lud07       number(20,6) DEFAULT '0',/*未税费用金额                           */
lud07t      number(20,6) DEFAULT '0',/*退款金额                               */
lud08       varchar2(60),            /*备注                                   */
lud09       varchar2(10),            /*no use 原门店编号                      */
ludlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ludplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lud10       varchar2(20)             /*待抵单号                               */
);

alter table lud_file add  constraint lud_pk primary key  (lud01,lud02) enable validate;
grant select on lud_file to tiptopgp;
grant update on lud_file to tiptopgp;
grant delete on lud_file to tiptopgp;
grant insert on lud_file to tiptopgp;
grant index on lud_file to public;
grant select on lud_file to ods;
