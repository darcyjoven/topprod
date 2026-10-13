/*
================================================================================
檔案代號:azwe_file
檔案名稱:数据群组设定数据
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table azwe_file
(
azwe01      varchar2(15) DEFAULT ' ' NOT NULL, /*Table名称*/
azwe02      varchar2(10) DEFAULT ' ' NOT NULL,
azwe03      varchar2(10) DEFAULT ' ' NOT NULL, /*工厂代码*/
azwedate    date,                    /*最近更改日                             */
azwegrup    varchar2(10),            /*资料所有部门                           */
azwemodu    varchar2(10),            /*资料更改者                             */
azweorig    varchar2(10),            /*资料建立部门                           */
azweoriu    varchar2(10),            /*资料建立者                             */
azweuser    varchar2(10)             /*资料所有者                             */
);

alter table azwe_file add  constraint azwe_pk primary key  (azwe01,azwe03) enable validate;
grant select on azwe_file to tiptopgp;
grant update on azwe_file to tiptopgp;
grant delete on azwe_file to tiptopgp;
grant insert on azwe_file to tiptopgp;
grant index on azwe_file to public;
grant select on azwe_file to ods;
