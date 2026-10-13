/*
================================================================================
檔案代號:gdb_file
檔案名稱:CR SQL Wizard  Table 记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdb_file
(
gdb01       varchar2(80) NOT NULL,   /*程序编号                               */
gdb02       varchar2(1) NOT NULL,    /*客制码                                 */
gdb03       varchar2(10) NOT NULL,   /*权限类型                               */
gdb04       varchar2(10) NOT NULL,   /*用户                                   */
gdb05       varchar2(15) NOT NULL,   /*档案名称                               */
gdb06       varchar2(1),             /*outer                                  */
gdb07       number(5) NOT NULL       /*序号                                   */
);

alter table gdb_file add  constraint gdb_pk primary key  (gdb01,gdb02,gdb03,gdb04,gdb05) enable validate;
grant select on gdb_file to tiptopgp;
grant update on gdb_file to tiptopgp;
grant delete on gdb_file to tiptopgp;
grant insert on gdb_file to tiptopgp;
grant index on gdb_file to public;
grant select on gdb_file to ods;
