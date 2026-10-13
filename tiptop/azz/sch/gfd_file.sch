/*
================================================================================
檔案代號:gfd_file
檔案名稱:客户开发记录 (资料同步清单)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gfd_file
(
gfd01       varchar2(20) NOT NULL,   /*开发单号                               */
gfd02       number(5) NOT NULL,      /*项次                                   */
gfd03       varchar2(1),             /*动作                                   */
gfd04       varchar2(1),             /*档案编号                               */
gfd05       varchar2(15),            /*档案编号                               */
gfd06       varchar2(80),            /*key字段的值1                           */
gfd07       varchar2(80)             /*key字段的值2                           */
);

alter table gfd_file add  constraint gfd_pk primary key  (gfd01,gfd02) enable validate;
grant select on gfd_file to tiptopgp;
grant update on gfd_file to tiptopgp;
grant delete on gfd_file to tiptopgp;
grant insert on gfd_file to tiptopgp;
grant index on gfd_file to public;
grant select on gfd_file to ods;
