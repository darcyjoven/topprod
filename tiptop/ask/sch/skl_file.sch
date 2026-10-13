/*
================================================================================
檔案代號:skl_file
檔案名稱:报工群组资料档
檔案目的:报工群组资料单头档
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table skl_file
(
skl01       varchar2(10) DEFAULT ' ' NOT NULL, /*群组编号*/
skl02       varchar2(80) DEFAULT ' ' NOT NULL, /*群组名称*/
skl03       varchar2(40) DEFAULT ' ' NOT NULL, /*款式料号*/
skl04       varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
sklacti     varchar2(1),             /*资料有效码                             */
skldate     date,                    /*资料有效码                             */
sklgrup     varchar2(10),            /*资料所属群组                           */
sklmodu     varchar2(10),            /*资料更改者                             */
skluser     varchar2(10),            /*资料用户                               */
sklorig     varchar2(10),            /*资料建立部门                           */
skloriu     varchar2(10)             /*资料建立者                             */
);

alter table skl_file add  constraint skl_pk primary key  (skl01,skl03) enable validate;
grant select on skl_file to tiptopgp;
grant update on skl_file to tiptopgp;
grant delete on skl_file to tiptopgp;
grant insert on skl_file to tiptopgp;
grant index on skl_file to public;
grant select on skl_file to ods;
