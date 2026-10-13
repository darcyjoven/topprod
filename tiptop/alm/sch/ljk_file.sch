/*
================================================================================
檔案代號:ljk_file
檔案名稱:合同变更优惠标准单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljk_file
(
ljk01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同变更单号*/
ljk02       number(5),               /*合同版本                               */
ljk03       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljk04       varchar2(10),            /*费用编号                               */
ljk05       varchar2(20),            /*优惠单号                               */
ljk06       date,                    /*开始日期                               */
ljk07       date,                    /*结束日期                               */
ljk08       number(20,6),            /*优惠金额                               */
ljklegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljkplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ljk_file add  constraint ljk_pk primary key  (ljk01,ljk03) enable validate;
grant select on ljk_file to tiptopgp;
grant update on ljk_file to tiptopgp;
grant delete on ljk_file to tiptopgp;
grant insert on ljk_file to tiptopgp;
grant index on ljk_file to public;
grant select on ljk_file to ods;
