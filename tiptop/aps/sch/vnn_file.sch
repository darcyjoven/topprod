/*
================================================================================
檔案代號:vnn_file
檔案名稱:APS工模具保修明细维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vnn_file
(
vnn01       varchar2(60) NOT NULL,   /*工模具编号                             */
vnn02       date NOT NULL,           /*开始时间(yyyy/mm/dd)                   */
vnn03       date,                    /*结束时间(yyyy/mm/dd)                   */
vnn021      varchar2(8) NOT NULL,    /*开始时间 (HH:MM)                       */
vnn031      varchar2(8)              /*结束时间 (HH:MM)                       */
);

alter table vnn_file add  constraint vnn_pk primary key  (vnn01,vnn02,vnn021) enable validate;
grant select on vnn_file to tiptopgp;
grant update on vnn_file to tiptopgp;
grant delete on vnn_file to tiptopgp;
grant insert on vnn_file to tiptopgp;
grant index on vnn_file to public;
grant select on vnn_file to ods;
