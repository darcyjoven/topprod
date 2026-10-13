/*
================================================================================
檔案代號:lnz_file
檔案名稱:月收入資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnz_file
(
lnz01       varchar2(10),            /*no use                                 */
lnz02       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位编号*/
lnz03       varchar2(10) DEFAULT ' ' NOT NULL, /*商户编号*/
lnz04       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
lnz05       varchar2(4) DEFAULT ' ' NOT NULL, /*所属年份*/
lnz06       varchar2(2) DEFAULT ' ' NOT NULL, /*所属月份*/
lnz07       number(12,2) DEFAULT '0' NOT NULL, /*金额*/
lnzcrat     date,                    /*资料创建日                             */
lnzlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnzstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lnz_file add  constraint lnz_pk primary key  (lnz02,lnz03,lnz04,lnz05,lnz06) enable validate;
grant select on lnz_file to tiptopgp;
grant update on lnz_file to tiptopgp;
grant delete on lnz_file to tiptopgp;
grant insert on lnz_file to tiptopgp;
grant index on lnz_file to public;
grant select on lnz_file to ods;
