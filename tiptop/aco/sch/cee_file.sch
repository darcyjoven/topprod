/*
================================================================================
檔案代號:cee_file
檔案名稱:海关单位对照档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cee_file
(
cee01       varchar2(4) DEFAULT ' ' NOT NULL, /*企业单位*/
cee02       varchar2(4),             /*海关单位                               */
cee03       varchar2(80),            /*海关单位说明                           */
ceeacti     varchar2(1),             /*资料有效码                             */
ceedate     date,                    /*最近更改日                             */
ceegrup     varchar2(10),            /*资料所有部门                           */
ceemodu     varchar2(10),            /*资料更改者                             */
ceeuser     varchar2(10),            /*资料所有者                             */
ceeorig     varchar2(10),            /*资料建立部门                           */
ceeoriu     varchar2(10)             /*资料建立者                             */
);

alter table cee_file add  constraint cee_pk primary key  (cee01) enable validate;
grant select on cee_file to tiptopgp;
grant update on cee_file to tiptopgp;
grant delete on cee_file to tiptopgp;
grant insert on cee_file to tiptopgp;
grant index on cee_file to public;
grant select on cee_file to ods;
