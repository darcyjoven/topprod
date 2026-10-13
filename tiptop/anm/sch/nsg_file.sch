/*
================================================================================
檔案代號:nsg_file
檔案名稱:销账明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nsg_file
(
nsg01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
nsg02       varchar2(30) DEFAULT ' ' NOT NULL, /*银行帐号*/
nsg03       date DEFAULT sysdate NOT NULL, /*交易日期*/
nsg04       number(5) DEFAULT '0' NOT NULL, /*交易序号*/
nsg05       varchar2(4),             /*币种                                   */
nsg06       number(20,6),            /*借方金额                               */
nsg07       number(20,6),            /*贷方金额                               */
nsg08       number(20,6),            /*余额                                   */
nsg09       varchar2(20),            /*支票号码                               */
nsg10       varchar2(10),            /*交易代码                               */
nsg11       varchar2(255)            /*备注                                   */
);

alter table nsg_file add  constraint nsg_pk primary key  (nsg01,nsg02,nsg03,nsg04) enable validate;
grant select on nsg_file to tiptopgp;
grant update on nsg_file to tiptopgp;
grant delete on nsg_file to tiptopgp;
grant insert on nsg_file to tiptopgp;
grant index on nsg_file to public;
grant select on nsg_file to ods;
