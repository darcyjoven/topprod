/*
================================================================================
檔案代號:ids_file
檔案名稱:ICD feature hold批号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table ids_file
(
ids01       varchar2(24) DEFAULT ' ' NOT NULL, /*批号*/
ids02       varchar2(1) DEFAULT ' ' NOT NULL, /*Hold type*/
idsacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
idsdate     date,                    /*最近更改日                             */
idsgrup     varchar2(10),            /*资料所有群                             */
idsmodu     varchar2(10),            /*资料更改者                             */
idsuser     varchar2(10),            /*资料所有者                             */
idsorig     varchar2(10),            /*资料建立部门                           */
idsoriu     varchar2(10),            /*资料建立者                             */
ids03       varchar2(1) DEFAULT ' ' NOT NULL, /*当前状态*/
ids04       varchar2(1) DEFAULT ' ' NOT NULL /*锁定状态*/
);

alter table ids_file add  constraint ids_pk primary key  (ids01) enable validate;
grant select on ids_file to tiptopgp;
grant update on ids_file to tiptopgp;
grant delete on ids_file to tiptopgp;
grant insert on ids_file to tiptopgp;
grant index on ids_file to public;
grant select on ids_file to ods;
