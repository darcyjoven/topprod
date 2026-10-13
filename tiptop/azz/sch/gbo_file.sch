/*
================================================================================
檔案代號:gbo_file
檔案名稱:部门可上线人数设置档
檔案目的:依照不同部门设置最大上线数
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gbo_file
(
gbo01       varchar2(10) NOT NULL,   /*部门编号                               */
gbo02       varchar2(1),             /*限制部门上线人数                       */
gbo03       number(10),              /*可上线人数                             */
gbo04       varchar2(1) DEFAULT '1' NOT NULL /*类型*/
);

alter table gbo_file add  constraint gbo_pk primary key  (gbo01,gbo04) enable validate;
grant select on gbo_file to tiptopgp;
grant update on gbo_file to tiptopgp;
grant delete on gbo_file to tiptopgp;
grant insert on gbo_file to tiptopgp;
grant index on gbo_file to public;
grant select on gbo_file to ods;
