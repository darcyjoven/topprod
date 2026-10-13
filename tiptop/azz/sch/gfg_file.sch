/*
================================================================================
檔案代號:gfg_file
檔案名稱:GP 5.2:权限过滤器主Table
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gfg_file
(
gfg01       varchar2(20) NOT NULL,   /*程序代码                               */
gfg02       varchar2(15),            /*对应主Table                            */
gfg03       varchar2(1),             /*no use                                 */
gfg04       varchar2(20),            /*no use                                 */
gfg05       varchar2(1),             /*no use                                 */
gfg06       varchar2(20),            /*no use                                 */
gfg07       varchar2(1),             /*AND/OR                                 */
gfg08       varchar2(255),           /*合并条件                               */
gfg09       varchar2(1),             /*no use                                 */
gfg10       varchar2(1)              /*程序类型                               */
);

alter table gfg_file add  constraint gfg_pk primary key  (gfg01) enable validate;
grant select on gfg_file to tiptopgp;
grant update on gfg_file to tiptopgp;
grant delete on gfg_file to tiptopgp;
grant insert on gfg_file to tiptopgp;
grant index on gfg_file to public;
grant select on gfg_file to ods;
