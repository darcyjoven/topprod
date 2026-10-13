/*
================================================================================
檔案代號:gcp_file
檔案名稱:触发器信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gcp_file
(
gcp01       varchar2(15) NOT NULL,   /*表名                                   */
gcp02       varchar2(30),            /*触发器名                               */
gcp03       varchar2(100),           /*触发器说明                             */
gcp04       varchar2(100),           /*其他参数                               */
gcp05       varchar2(1),             /*已经建立                               */
gcp06       varchar2(30),            /*触发器全称                             */
gcp07       varchar2(1)              /*是否共用                               */
);

alter table gcp_file add  constraint gcp_pk primary key  (gcp01) enable validate;
grant select on gcp_file to tiptopgp;
grant update on gcp_file to tiptopgp;
grant delete on gcp_file to tiptopgp;
grant insert on gcp_file to tiptopgp;
grant index on gcp_file to public;
grant select on gcp_file to ods;
