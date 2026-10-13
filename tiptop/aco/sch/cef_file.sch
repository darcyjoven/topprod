/*
================================================================================
檔案代號:cef_file
檔案名稱:海关币别对照档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cef_file
(
cef01       varchar2(4) DEFAULT ' ' NOT NULL, /*企业币种*/
cef02       varchar2(4),             /*海关币种                               */
cef03       varchar2(80),            /*海关币种说明                           */
cefacti     varchar2(1),             /*资料有效码                             */
cefdate     date,                    /*最近更改日                             */
cefgrup     varchar2(10),            /*资料所有部门                           */
cefmodu     varchar2(10),            /*资料更改者                             */
cefuser     varchar2(10),            /*资料所有者                             */
ceforig     varchar2(10),            /*资料建立部门                           */
ceforiu     varchar2(10)             /*资料建立者                             */
);

alter table cef_file add  constraint cef_pk primary key  (cef01) enable validate;
grant select on cef_file to tiptopgp;
grant update on cef_file to tiptopgp;
grant delete on cef_file to tiptopgp;
grant insert on cef_file to tiptopgp;
grant index on cef_file to public;
grant select on cef_file to ods;
