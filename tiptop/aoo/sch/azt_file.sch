/*
================================================================================
檔案代號:azt_file
檔案名稱:法人基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table azt_file
(
azt01       varchar2(10) DEFAULT ' ' NOT NULL, /*法人编号*/
azt02       varchar2(80),            /*法人名称                               */
azt03       varchar2(10),            /*上层法人编号                           */
azt04       varchar2(80),            /*上层法人名称                           */
aztacti     varchar2(1),             /*资料有效码                             */
aztdate     date,                    /*最近更改日                             */
aztgrup     varchar2(10),            /*资料所有部门                           */
aztmodu     varchar2(10),            /*资料更改者                             */
aztuser     varchar2(10),            /*资料所有者                             */
aztorig     varchar2(10),            /*资料建立部门                           */
aztoriu     varchar2(10)             /*资料建立者                             */
);

grant select on azt_file to tiptopgp;
grant update on azt_file to tiptopgp;
grant delete on azt_file to tiptopgp;
grant insert on azt_file to tiptopgp;
grant index on azt_file to public;
grant select on azt_file to ods;
