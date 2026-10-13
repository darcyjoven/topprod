/*
================================================================================
檔案代號:idl_file
檔案名稱:ICD批号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table idl_file
(
idl01       varchar2(24) DEFAULT ' ' NOT NULL, /*生产批号*/
idl02       varchar2(2),             /*最大编号                               */
idl03       varchar2(10),            /*no use                                 */
idl04       varchar2(10)             /*no use                                 */
);

alter table idl_file add  constraint idl_pk primary key  (idl01) enable validate;
grant select on idl_file to tiptopgp;
grant update on idl_file to tiptopgp;
grant delete on idl_file to tiptopgp;
grant insert on idl_file to tiptopgp;
grant index on idl_file to public;
grant select on idl_file to ods;
