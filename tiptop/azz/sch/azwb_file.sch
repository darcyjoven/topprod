/*
================================================================================
檔案代號:azwb_file
檔案名稱:Global字段设定数据
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table azwb_file
(
azwb01      varchar2(15) DEFAULT ' ' NOT NULL, /*Table名称*/
azwb02      varchar2(30) DEFAULT ' ' NOT NULL, /*字段代码*/
azwbdate    date,                    /*最近更改日                             */
azwbgrup    varchar2(10),            /*资料所有部门                           */
azwbmodu    varchar2(10),            /*资料更改者                             */
azwborig    varchar2(10),            /*资料建立部门                           */
azwboriu    varchar2(10),            /*资料建立者                             */
azwbuser    varchar2(10)             /*资料所有者                             */
);

alter table azwb_file add  constraint azwb_pk primary key  (azwb01,azwb02) enable validate;
grant select on azwb_file to tiptopgp;
grant update on azwb_file to tiptopgp;
grant delete on azwb_file to tiptopgp;
grant insert on azwb_file to tiptopgp;
grant index on azwb_file to public;
grant select on azwb_file to ods;
