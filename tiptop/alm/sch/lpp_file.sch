/*
================================================================================
檔案代號:lpp_file
檔案名稱:会员补积分支付明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lpp_file
(
lpp01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lpp02       varchar2(20) DEFAULT ' ' NOT NULL, /*交款单号*/
lpp03       number(5) DEFAULT '0' NOT NULL, /*项次*/
lpp04       number(20,6),            /*交款金额                               */
lpplegal    varchar2(10) NOT NULL,   /*所属法人                               */
lppplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lpp_file add  constraint lpp_pk primary key  (lpp01,lpp02,lpp03) enable validate;
grant select on lpp_file to tiptopgp;
grant update on lpp_file to tiptopgp;
grant delete on lpp_file to tiptopgp;
grant insert on lpp_file to tiptopgp;
grant index on lpp_file to public;
grant select on lpp_file to ods;
