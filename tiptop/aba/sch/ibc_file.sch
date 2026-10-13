/*
================================================================================
檔案代號:ibc_file
檔案名稱:包装单资料档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ibc_file
(
ibc00       varchar2(1) DEFAULT '1' NOT NULL, /*类型*/
ibc01       varchar2(40) DEFAULT ' ' NOT NULL, /*成品料号*/
ibc02       number(5) DEFAULT '1' NOT NULL, /*项次*/
ibc03       number(5) DEFAULT '0' NOT NULL, /*总包数*/
ibc04       varchar2(40),            /*组合件料号                             */
ibc05       number(5),               /*包号                                   */
ibc06       number(15,3),            /*数量                                   */
ibc07       number(15,3),            /*成品包数量                             */
ibc08       varchar2(10) DEFAULT ' ' NOT NULL /*系列*/
);

alter table ibc_file add  constraint ibc_pk primary key  (ibc01,ibc02,ibc08) enable validate;
grant select on ibc_file to tiptopgp;
grant update on ibc_file to tiptopgp;
grant delete on ibc_file to tiptopgp;
grant insert on ibc_file to tiptopgp;
grant index on ibc_file to public;
grant select on ibc_file to ods;
