/*
================================================================================
檔案代號:gfh_file
檔案名稱:GP 5.2:权限过滤器条件设定Table
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gfh_file
(
gfh01       varchar2(20) NOT NULL,   /*程序代码                               */
gfh02       varchar2(10) NOT NULL,   /*过滤条件编号                           */
gfh03       varchar2(80),            /*说明                                   */
gfh04       varchar2(255),           /*其他特殊条件                           */
gfh05       varchar2(255),           /*最终过滤条件                           */
gfh06       varchar2(1)              /*AND/OR                                 */
);

alter table gfh_file add  constraint gfh_pk primary key  (gfh01,gfh02) enable validate;
grant select on gfh_file to tiptopgp;
grant update on gfh_file to tiptopgp;
grant delete on gfh_file to tiptopgp;
grant insert on gfh_file to tiptopgp;
grant index on gfh_file to public;
grant select on gfh_file to ods;
