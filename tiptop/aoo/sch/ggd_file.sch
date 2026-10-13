/*
================================================================================
檔案代號:ggd_file
檔案名稱:库存异动类别档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ggd_file
(
ggd01       varchar2(10) DEFAULT ' ' NOT NULL, /*库存异动类型*/
ggd02       varchar2(80),            /*类型说明                               */
ggdacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ggddate     date,                    /*最近更改日                             */
ggdgrup     varchar2(10),            /*资料所有群                             */
ggdmodu     varchar2(10),            /*资料更改者                             */
ggdorig     varchar2(10),            /*资料建立部门                           */
ggdoriu     varchar2(10),            /*资料建立者                             */
ggduser     varchar2(10)             /*资料所有者                             */
);

alter table ggd_file add  constraint ggd_pk primary key  (ggd01) enable validate;
grant select on ggd_file to tiptopgp;
grant update on ggd_file to tiptopgp;
grant delete on ggd_file to tiptopgp;
grant insert on ggd_file to tiptopgp;
grant index on ggd_file to public;
grant select on ggd_file to ods;
