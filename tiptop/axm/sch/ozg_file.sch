/*
================================================================================
檔案代號:ozg_file
檔案名稱:其他运输基本代码档
檔案目的:记录其他运输基本资料
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ozg_file
(
ozg01       varchar2(10) NOT NULL,   /*其他运输代码                           */
ozg02       varchar2(60),            /*其他运输说明                           */
ozgacti     varchar2(1),             /*资料有效码                             */
ozguser     varchar2(10),            /*资料所有者                             */
ozggrup     varchar2(6),             /*资料所有部门                           */
ozgmodu     varchar2(10),            /*资料更改者                             */
ozgdate     date,                    /*最近更改日                             */
ozgorig     varchar2(10),            /*资料建立部门                           */
ozgoriu     varchar2(10)             /*资料建立者                             */
);

alter table ozg_file add  constraint ozg_pk primary key  (ozg01) enable validate;
grant select on ozg_file to tiptopgp;
grant update on ozg_file to tiptopgp;
grant delete on ozg_file to tiptopgp;
grant insert on ozg_file to tiptopgp;
grant index on ozg_file to public;
grant select on ozg_file to ods;
