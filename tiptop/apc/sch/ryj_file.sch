/*
================================================================================
檔案代號:ryj_file
檔案名稱:全局表资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table ryj_file
(
ryj01       varchar2(30) DEFAULT ' ' NOT NULL, /*OWNER*/
ryj02       varchar2(30) DEFAULT ' ' NOT NULL, /*SYNONYM_NAME*/
ryj03       varchar2(30),            /*TABLE_OWNER                            */
ryj04       varchar2(30) DEFAULT ' ' NOT NULL, /*TABLE_NAME*/
ryj05       varchar2(200),           /*DB_LINK                                */
ryjacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
ryjcrat     date,                    /*资料创建日                             */
ryjdate     date,                    /*资料更改日                             */
ryjgrup     varchar2(10),            /*资料所有部门                           */
ryjmodu     varchar2(10),            /*资料更改者                             */
ryjorig     varchar2(10),            /*资料建立部门                           */
ryjoriu     varchar2(10),            /*资料建立者                             */
ryjuser     varchar2(10)             /*资料所有者                             */
);

alter table ryj_file add  constraint ryj_pk primary key  (ryj01) enable validate;
grant select on ryj_file to tiptopgp;
grant update on ryj_file to tiptopgp;
grant delete on ryj_file to tiptopgp;
grant insert on ryj_file to tiptopgp;
grant index on ryj_file to public;
grant select on ryj_file to ods;
