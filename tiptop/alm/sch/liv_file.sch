/*
================================================================================
檔案代號:liv_file
檔案名稱:合同日核算档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table liv_file
(
liv01       varchar2(20) DEFAULT ' ' NOT NULL, /*合约编号*/
liv02       number(5),               /*合同版本号                             */
liv03       number(5) DEFAULT '0' NOT NULL, /*项次*/
liv04       date,                    /*分摊日期                               */
liv05       varchar2(10),            /*费用编号                               */
liv06       number(20,6),            /*费用金额                               */
liv07       varchar2(20),            /*参考单号                               */
liv071      number(5),               /*参考单号版本号                         */
liv08       varchar2(1) DEFAULT ' ' NOT NULL, /*数据类型*/
liv09       varchar2(1) DEFAULT ' ' NOT NULL, /*优惠类型*/
livlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
livplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table liv_file add  constraint liv_pk primary key  (liv01,liv03) enable validate;
grant select on liv_file to tiptopgp;
grant update on liv_file to tiptopgp;
grant delete on liv_file to tiptopgp;
grant insert on liv_file to tiptopgp;
grant index on liv_file to public;
grant select on liv_file to ods;
