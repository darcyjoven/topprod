/*
================================================================================
檔案代號:ryf_file
檔案名稱:城区资料维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ryf_file
(
ryf01       varchar2(10) DEFAULT ' ' NOT NULL, /*城区编号*/
ryf02       varchar2(80),            /*城区名称                               */
ryf03       varchar2(10),            /*隶属城市                               */
ryfacti     varchar2(1),             /*资料有效码                             */
ryfcrat     date,                    /*资料创建日                             */
ryfdate     date,                    /*最近更改日                             */
ryfgrup     varchar2(10),            /*资料所有部门                           */
ryfmodu     varchar2(10),            /*资料更改者                             */
ryfuser     varchar2(10),            /*资料所有者                             */
ryforig     varchar2(10),            /*资料建立部门                           */
ryforiu     varchar2(10)             /*资料建立者                             */
);

alter table ryf_file add  constraint ryf_pk primary key  (ryf01) enable validate;
grant select on ryf_file to tiptopgp;
grant update on ryf_file to tiptopgp;
grant delete on ryf_file to tiptopgp;
grant insert on ryf_file to tiptopgp;
grant index on ryf_file to public;
grant select on ryf_file to ods;
