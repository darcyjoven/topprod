/*
================================================================================
檔案代號:ozb_file
檔案名稱:航运基本代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ozb_file
(
ozb01       varchar2(10) NOT NULL,   /*海运代码                               */
ozb02       varchar2(80),            /*海运说明                               */
ozbacti     varchar2(1),             /*资料有效码                             */
ozbuser     varchar2(10),            /*资料所有者                             */
ozbgrup     varchar2(10),            /*资料所有部门                           */
ozbmodu     varchar2(10),            /*资料更改者                             */
ozbdate     date,                    /*最近更改日                             */
ozborig     varchar2(10),            /*资料建立部门                           */
ozboriu     varchar2(10)             /*资料建立者                             */
);

alter table ozb_file add  constraint ozb_pk primary key  (ozb01) enable validate;
grant select on ozb_file to tiptopgp;
grant update on ozb_file to tiptopgp;
grant delete on ozb_file to tiptopgp;
grant insert on ozb_file to tiptopgp;
grant index on ozb_file to public;
grant select on ozb_file to ods;
