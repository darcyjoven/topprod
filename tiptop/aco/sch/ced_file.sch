/*
================================================================================
檔案代號:ced_file
檔案名稱:成交方式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ced_file
(
ced01       varchar2(10) DEFAULT ' ' NOT NULL, /*成交方式*/
ced02       varchar2(80),            /*成交方式说明                           */
cedacti     varchar2(1),             /*资料有效码                             */
ceddate     date,                    /*最近更改日                             */
cedgrup     varchar2(10),            /*资料所有部门                           */
cedmodu     varchar2(10),            /*资料更改者                             */
ceduser     varchar2(10),            /*资料所有者                             */
cedorig     varchar2(10),            /*资料建立部门                           */
cedoriu     varchar2(10)             /*资料建立者                             */
);

alter table ced_file add  constraint ced_pk primary key  (ced01) enable validate;
grant select on ced_file to tiptopgp;
grant update on ced_file to tiptopgp;
grant delete on ced_file to tiptopgp;
grant insert on ced_file to tiptopgp;
grant index on ced_file to public;
grant select on ced_file to ods;
