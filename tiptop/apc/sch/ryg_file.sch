/*
================================================================================
檔案代號:ryg_file
檔案名稱:POS传输营运中心资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table ryg_file
(
ryg00       varchar2(40) DEFAULT ' ' NOT NULL, /*POS传输DB*/
ryg01       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
ryg02       varchar2(40) DEFAULT ' ' NOT NULL, /*DBlink名称*/
rygacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
rygcrat     date,                    /*资料创建日                             */
rygdate     date,                    /*资料更改日                             */
ryggrup     varchar2(10),            /*资料所有部门                           */
rygmodu     varchar2(10),            /*资料更改者                             */
rygorig     varchar2(10),            /*资料建立部门                           */
rygoriu     varchar2(10),            /*资料建立者                             */
ryguser     varchar2(10),            /*资料所有者                             */
ryg03       varchar2(10)
);

alter table ryg_file add  constraint ryg_pk primary key  (ryg01) enable validate;
grant select on ryg_file to tiptopgp;
grant update on ryg_file to tiptopgp;
grant delete on ryg_file to tiptopgp;
grant insert on ryg_file to tiptopgp;
grant index on ryg_file to public;
grant select on ryg_file to ods;
