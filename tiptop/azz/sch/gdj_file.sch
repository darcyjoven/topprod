/*
================================================================================
檔案代號:gdj_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdj_file
(
gdj01       varchar2(30) DEFAULT ' ' NOT NULL, /*程序编号*/
gdj02       varchar2(1) DEFAULT ' ' NOT NULL, /*权限类型*/
gdj03       varchar2(10) DEFAULT ' ' NOT NULL, /*设限使用者/部门*/
gdjdate     date,                    /*最近更改日                             */
gdjgrup     varchar2(10),            /*资料所有群                             */
gdjmodu     varchar2(10),            /*资料更改者                             */
gdjorig     varchar2(10),            /*资料建立部门                           */
gdjoriu     varchar2(10),            /*资料建立者                             */
gdjuser     varchar2(10)             /*资料所有者                             */
);

create        index gdj_01 on gdj_file (gdj01);
alter table gdj_file add  constraint gdj_pk primary key  (gdj01,gdj02,gdj03) enable validate;
grant select on gdj_file to tiptopgp;
grant update on gdj_file to tiptopgp;
grant delete on gdj_file to tiptopgp;
grant insert on gdj_file to tiptopgp;
grant index on gdj_file to public;
grant select on gdj_file to ods;
