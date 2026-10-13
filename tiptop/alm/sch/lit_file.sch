/*
================================================================================
檔案代號:lit_file
檔案名稱:合同优惠标准信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lit_file
(
lit01       varchar2(20) DEFAULT ' ' NOT NULL, /*合约编号*/
lit02       number(5),               /*合同版本号                             */
lit03       number(5) DEFAULT '0' NOT NULL, /*项次*/
lit04       varchar2(10),            /*费用编号                               */
lit05       varchar2(20),            /*优惠单号                               */
lit06       date,                    /*开始日期                               */
lit07       date,                    /*结束日期                               */
lit08       number(20,6),            /*优惠金额                               */
litlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
litplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lit_file add  constraint lit_pk primary key  (lit01,lit03) enable validate;
grant select on lit_file to tiptopgp;
grant update on lit_file to tiptopgp;
grant delete on lit_file to tiptopgp;
grant insert on lit_file to tiptopgp;
grant index on lit_file to public;
grant select on lit_file to ods;
