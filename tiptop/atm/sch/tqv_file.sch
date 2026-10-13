/*
================================================================================
檔案代號:tqv_file
檔案名稱:现金折扣单折扣明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tqv_file
(
tqv01       varchar2(20) DEFAULT ' ' NOT NULL, /*现金折扣单号*/
tqv02       number(5) DEFAULT '0' NOT NULL, /*项次*/
tqv03       number(5) DEFAULT '0' NOT NULL, /*来源合同折扣条件项次*/
tqv04       varchar2(10),            /*费用编号                               */
tqv05       number(20,6),            /*折扣金额                               */
tqv06       varchar2(1),             /*预提否 ，y/n                           */
tqv07       varchar2(100),           /*说明                                   */
tqvplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tqvlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tqv_file add  constraint tqv_pk primary key  (tqv01,tqv02) enable validate;
grant select on tqv_file to tiptopgp;
grant update on tqv_file to tiptopgp;
grant delete on tqv_file to tiptopgp;
grant insert on tqv_file to tiptopgp;
grant index on tqv_file to public;
grant select on tqv_file to ods;
