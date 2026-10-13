/*
================================================================================
檔案代號:ryh_file
檔案名稱:收银最低折扣设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ryh_file
(
ryh01       varchar2(1) DEFAULT ' ' NOT NULL, /*收银操作等级*/
ryh02       number(5),               /*最低折扣率                             */
ryhacti     varchar2(1),             /*资料有效码                             */
ryhcrat     date,                    /*资料创建日                             */
ryhdate     date,                    /*最近更改日                             */
ryhgrup     varchar2(10),            /*资料所有部门                           */
ryhmodu     varchar2(10),            /*资料更改者                             */
ryhuser     varchar2(10),            /*资料所有者                             */
ryhorig     varchar2(10),            /*资料建立部门                           */
ryhoriu     varchar2(10)             /*资料建立者                             */
);

alter table ryh_file add  constraint ryh_pk primary key  (ryh01) enable validate;
grant select on ryh_file to tiptopgp;
grant update on ryh_file to tiptopgp;
grant delete on ryh_file to tiptopgp;
grant insert on ryh_file to tiptopgp;
grant index on ryh_file to public;
grant select on ryh_file to ods;
