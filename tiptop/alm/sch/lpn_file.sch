/*
================================================================================
檔案代號:lpn_file
檔案名稱:会员发卡支付明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lpn_file
(
lpn01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lpn02       varchar2(20) DEFAULT ' ' NOT NULL, /*交款单号*/
lpn03       number(5) DEFAULT '0' NOT NULL, /*项次*/
lpnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lpnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lpn04       number(20,2) DEFAULT '0' NOT NULL /*交款金额*/
);

alter table lpn_file add  constraint lpn_pk primary key  (lpn01,lpn02,lpn03) enable validate;
grant select on lpn_file to tiptopgp;
grant update on lpn_file to tiptopgp;
grant delete on lpn_file to tiptopgp;
grant insert on lpn_file to tiptopgp;
grant index on lpn_file to public;
grant select on lpn_file to ods;
