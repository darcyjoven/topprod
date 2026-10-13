/*
================================================================================
檔案代號:luj_file
檔案名稱:交款单单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table luj_file
(
luj01       varchar2(20) DEFAULT ' ' NOT NULL, /*交款单号*/
luj02       number(5) DEFAULT '0' NOT NULL, /*项次*/
luj03       varchar2(20),            /*费用单号                               */
luj04       number(5),               /*费用单项次                             */
luj05       varchar2(10),            /*费用编号                               */
luj06       number(20,6),            /*交款金额                               */
luj07       varchar2(20),            /*待抵单号                               */
lujlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lujplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table luj_file add  constraint luj_pk primary key  (luj01,luj02) enable validate;
grant select on luj_file to tiptopgp;
grant update on luj_file to tiptopgp;
grant delete on luj_file to tiptopgp;
grant insert on luj_file to tiptopgp;
grant index on luj_file to public;
grant select on luj_file to ods;
