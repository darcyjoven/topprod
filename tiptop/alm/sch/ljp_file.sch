/*
================================================================================
檔案代號:ljp_file
檔案名稱:合同变更日核算档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljp_file
(
ljp01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同变更单号*/
ljp02       number(5),               /*合同版本号                             */
ljp03       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljp04       date,                    /*分摊日期                               */
ljp05       varchar2(10),            /*费用编号                               */
ljp06       number(20,6),            /*费用金额                               */
ljp07       varchar2(20),            /*参考单号                               */
ljp071      number(5),               /*参考单号版本号                         */
ljp08       varchar2(1) DEFAULT ' ' NOT NULL, /*数据类型*/
ljp09       varchar2(1) DEFAULT ' ' NOT NULL, /*优惠类型*/
ljplegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljpplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ljp_file add  constraint ljp_pk primary key  (ljp01,ljp03) enable validate;
grant select on ljp_file to tiptopgp;
grant update on ljp_file to tiptopgp;
grant delete on ljp_file to tiptopgp;
grant insert on ljp_file to tiptopgp;
grant index on ljp_file to public;
grant select on ljp_file to ods;
