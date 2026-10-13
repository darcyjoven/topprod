/*
================================================================================
檔案代號:azy_file
檔案名稱:集团架构Local档案设定资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table azy_file
(
azy01       varchar2(20) DEFAULT ' ' NOT NULL, /*Base Data DB*/
azy02       varchar2(15) DEFAULT ' ' NOT NULL, /*档案编号*/
azyacti     varchar2(1),             /*资料有效码                             */
azydate     date,                    /*最近更改日                             */
azygrup     varchar2(10),            /*资料所有部门                           */
azymodu     varchar2(10),            /*资料更改者                             */
azyuser     varchar2(10),            /*资料所有者                             */
azyorig     varchar2(10),            /*资料建立部门                           */
azyoriu     varchar2(10)             /*资料建立者                             */
);

alter table azy_file add  constraint azy_pk primary key  (azy01,azy02) enable validate;
grant select on azy_file to tiptopgp;
grant update on azy_file to tiptopgp;
grant delete on azy_file to tiptopgp;
grant insert on azy_file to tiptopgp;
grant index on azy_file to public;
grant select on azy_file to ods;
