/*
================================================================================
檔案代號:azwc_file
檔案名稱:数据群组基本数据
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table azwc_file
(
azwc01      varchar2(20) DEFAULT ' ' NOT NULL,
azwc02      varchar2(40),            /*代码说明                               */
azwcacti    varchar2(1) DEFAULT 'Y' NOT NULL, /*有效否*/
azwcdate    date,                    /*最近更改日                             */
azwcgrup    varchar2(10),            /*资料所有部门                           */
azwcmodu    varchar2(10),            /*资料更改者                             */
azwcorig    varchar2(10),            /*资料建立部门                           */
azwcoriu    varchar2(10),            /*资料建立者                             */
azwcuser    varchar2(10)             /*资料所有者                             */
);

alter table azwc_file add  constraint azwc_pk primary key  (azwc01) enable validate;
grant select on azwc_file to tiptopgp;
grant update on azwc_file to tiptopgp;
grant delete on azwc_file to tiptopgp;
grant insert on azwc_file to tiptopgp;
grant index on azwc_file to public;
grant select on azwc_file to ods;
