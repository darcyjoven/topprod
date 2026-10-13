/*
================================================================================
檔案代號:top_file
檔案名稱:地级市编号维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table top_file
(
top01       varchar2(10) NOT NULL,   /*地级市编号                             */
top02       varchar2(80),            /*地级市名称                             */
top03       varchar2(10),            /*省别编号                               */
topacti     varchar2(1)              /*有效否                                 */
);

alter table top_file add  constraint top_pk primary key  (top01) enable validate;
grant select on top_file to tiptopgp;
grant update on top_file to tiptopgp;
grant delete on top_file to tiptopgp;
grant insert on top_file to tiptopgp;
grant index on top_file to public;
grant select on top_file to ods;
