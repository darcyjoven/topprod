/*
================================================================================
檔案代號:ryb_file
檔案名稱:城市资料维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ryb_file
(
ryb01       varchar2(10) DEFAULT ' ' NOT NULL, /*城市编号*/
ryb02       varchar2(80),            /*城市名称                               */
ryb03       varchar2(10),            /*隶属省别                               */
rybacti     varchar2(1),             /*资料有效码                             */
rybcrat     date,                    /*资料创建日                             */
rybdate     date,                    /*最近更改日                             */
rybgrup     varchar2(10),            /*资料所有部门                           */
rybmodu     varchar2(10),            /*资料更改者                             */
rybuser     varchar2(10),            /*资料所有者                             */
ryborig     varchar2(10),            /*资料建立部门                           */
ryboriu     varchar2(10)             /*资料建立者                             */
);

alter table ryb_file add  constraint ryb_pk primary key  (ryb01) enable validate;
grant select on ryb_file to tiptopgp;
grant update on ryb_file to tiptopgp;
grant delete on ryb_file to tiptopgp;
grant insert on ryb_file to tiptopgp;
grant index on ryb_file to public;
grant select on ryb_file to ods;
