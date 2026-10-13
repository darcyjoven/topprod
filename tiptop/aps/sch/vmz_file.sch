/*
================================================================================
檔案代號:vmz_file
檔案名稱:aps 採購令維護檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vmz_file
(
vmz01       varchar2(60) DEFAULT ' ' NOT NULL, /*采购单编号*/
vmz12       number(1),               /*是否保留                               */
vmz16       varchar2(60),            /*供给法则编号                           */
vmz25       number(1),               /*是否受供给法则限制, 0;否 1:是          */
vmzlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vmzplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vmz_file add  constraint vmz_pk primary key  (vmz01) enable validate;
grant select on vmz_file to tiptopgp;
grant update on vmz_file to tiptopgp;
grant delete on vmz_file to tiptopgp;
grant insert on vmz_file to tiptopgp;
grant index on vmz_file to public;
grant select on vmz_file to ods;
