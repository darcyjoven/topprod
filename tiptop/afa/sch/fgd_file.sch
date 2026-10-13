/*
================================================================================
檔案代號:fgd_file
檔案名稱:校定项目基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fgd_file
(
fgd01       varchar2(6) NOT NULL,    /*校定项目                               */
fgd02       varchar2(80),            /*校定项目名称                           */
fgdacti     varchar2(1),             /*资料有效码                             */
fgduser     varchar2(10),            /*资料所有者                             */
fgdgrup     varchar2(10),            /*资料所有群                             */
fgdmodu     varchar2(10),            /*资料更改者                             */
fgddate     date,                    /*最近更改日                             */
fgdorig     varchar2(10),            /*资料建立部门                           */
fgdoriu     varchar2(10)             /*资料建立者                             */
);

alter table fgd_file add  constraint fgd_pk primary key  (fgd01) enable validate;
grant select on fgd_file to tiptopgp;
grant update on fgd_file to tiptopgp;
grant delete on fgd_file to tiptopgp;
grant insert on fgd_file to tiptopgp;
grant index on fgd_file to public;
grant select on fgd_file to ods;
