/*
================================================================================
檔案代號:cec_file
檔案名稱:用途代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cec_file
(
cec01       varchar2(10) DEFAULT ' ' NOT NULL, /*用途代码*/
cec02       varchar2(80),            /*用途说明                               */
cecacti     varchar2(1),             /*资料有效码                             */
cecdate     date,                    /*最近更改日                             */
cecgrup     varchar2(10),            /*资料所有部门                           */
cecmodu     varchar2(10),            /*资料更改者                             */
cecuser     varchar2(10),            /*资料所有者                             */
cecorig     varchar2(10),            /*资料建立部门                           */
cecoriu     varchar2(10)             /*资料建立者                             */
);

alter table cec_file add  constraint cec_pk primary key  (cec01) enable validate;
grant select on cec_file to tiptopgp;
grant update on cec_file to tiptopgp;
grant delete on cec_file to tiptopgp;
grant insert on cec_file to tiptopgp;
grant index on cec_file to public;
grant select on cec_file to ods;
