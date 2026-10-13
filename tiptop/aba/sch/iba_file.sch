/*
================================================================================
檔案代號:iba_file
檔案名稱:条码基本资料-主档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table iba_file
(
iba01       varchar2(80) DEFAULT ' ' NOT NULL, /*条码编号*/
iba02       varchar2(1),             /*条码组成1(类型)                        */
iba03       varchar2(40),            /*条码组成2                              */
iba04       varchar2(40),            /*条码组成3                              */
iba05       varchar2(40),            /*条码组成4                              */
iba06       varchar2(40),            /*条码组成5                              */
iba07       varchar2(40),            /*条码组成6                              */
iba08       varchar2(40),            /*条码组成7                              */
iba09       varchar2(40),            /*条码组成8                              */
iba10       varchar2(40),            /*条码组成9                              */
iba11       varchar2(40)             /*条码组成10                             */
);

alter table iba_file add  constraint iba_pk primary key  (iba01) enable validate;
grant select on iba_file to tiptopgp;
grant update on iba_file to tiptopgp;
grant delete on iba_file to tiptopgp;
grant insert on iba_file to tiptopgp;
grant index on iba_file to public;
grant select on iba_file to ods;
