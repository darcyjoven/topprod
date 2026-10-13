/*
================================================================================
檔案代號:ljl_file
檔案名稱:合同变更其他费用单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljl_file
(
ljl01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同变更单号*/
ljl02       number(5),               /*合同版本                               */
ljl03       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljl04       varchar2(10),            /*费用编号                               */
ljl05       date,                    /*开始日期                               */
ljl06       date,                    /*结束日期                               */
ljl07       number(20,6),            /*费用金额                               */
ljllegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljlplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ljl_file add  constraint ljl_pk primary key  (ljl01,ljl03) enable validate;
grant select on ljl_file to tiptopgp;
grant update on ljl_file to tiptopgp;
grant delete on ljl_file to tiptopgp;
grant insert on ljl_file to tiptopgp;
grant index on ljl_file to public;
grant select on ljl_file to ods;
