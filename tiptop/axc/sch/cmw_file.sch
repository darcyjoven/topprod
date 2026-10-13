/*
================================================================================
檔案代號:cmw_file
檔案名稱:LCM 除外仓库档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cmw_file
(
cmw01       varchar2(10) DEFAULT ' ' NOT NULL, /*除外仓库编号*/
cmwdate     date,                    /*最近更改日                             */
cmwgrup     varchar2(10),            /*资料所有部门                           */
cmwmodu     varchar2(10),            /*资料更改者                             */
cmwuser     varchar2(10),            /*资料所有者                             */
cmworig     varchar2(10),            /*资料建立部门                           */
cmworiu     varchar2(10)             /*资料建立者                             */
);

alter table cmw_file add  constraint cmw_pk primary key  (cmw01) enable validate;
grant select on cmw_file to tiptopgp;
grant update on cmw_file to tiptopgp;
grant delete on cmw_file to tiptopgp;
grant insert on cmw_file to tiptopgp;
grant index on cmw_file to public;
grant select on cmw_file to ods;
