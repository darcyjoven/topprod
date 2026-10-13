/*
================================================================================
檔案代號:azwd_file
檔案名稱:ods资料库清单
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table azwd_file
(
azwd01      varchar2(20) DEFAULT ' ' NOT NULL, /*数据库代码*/
azwddate    date,                    /*最近更改日                             */
azwdgrup    varchar2(10),            /*资料所有部门                           */
azwdmodu    varchar2(10),            /*资料更改者                             */
azwdorig    varchar2(10),            /*资料建立部门                           */
azwdoriu    varchar2(10),            /*资料建立者                             */
azwduser    varchar2(10)             /*资料所有者                             */
);

alter table azwd_file add  constraint azwd_pk primary key  (azwd01) enable validate;
grant select on azwd_file to tiptopgp;
grant update on azwd_file to tiptopgp;
grant delete on azwd_file to tiptopgp;
grant insert on azwd_file to tiptopgp;
grant index on azwd_file to public;
grant select on azwd_file to ods;
