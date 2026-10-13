/*
================================================================================
檔案代號:lpw_file
檔案名稱:储值卡退余额数据单身付款方式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lpw_file
(
lpw00       varchar2(10),            /*no use                                 */
lpw01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号(0-储值卡销售 1-储值 */
lpw02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lpw03       varchar2(1),             /*交款类别(0-现金 1-转账)                */
lpw04       number(20,2),            /*金额(0-现金 1 -银行卡 2-支票)          */
lpwlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lpwplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lpw_file add  constraint lpw_pk primary key  (lpw01,lpw02) enable validate;
grant select on lpw_file to tiptopgp;
grant update on lpw_file to tiptopgp;
grant delete on lpw_file to tiptopgp;
grant insert on lpw_file to tiptopgp;
grant index on lpw_file to public;
grant select on lpw_file to ods;
