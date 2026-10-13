/*
================================================================================
檔案代號:gfj_file
檔案名稱:权限过滤器单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gfj_file
(
gfj01       varchar2(20) NOT NULL,   /*程序代码                               */
gfj02       number(5) DEFAULT '0' NOT NULL, /*序号*/
gfj03       number(10),              /*过滤方式                               */
gfj04       varchar2(255),           /*代码                                   */
gfj05       varchar2(10)             /*过滤条件编号                           */
);

alter table gfj_file add  constraint gfj_pk primary key  (gfj01,gfj02) enable validate;
grant select on gfj_file to tiptopgp;
grant update on gfj_file to tiptopgp;
grant delete on gfj_file to tiptopgp;
grant insert on gfj_file to tiptopgp;
grant index on gfj_file to public;
grant select on gfj_file to ods;
