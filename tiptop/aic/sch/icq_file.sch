/*
================================================================================
檔案代號:icq_file
檔案名稱:ICD厂商wafer site资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table icq_file
(
icq01       varchar2(10) NOT NULL,   /*供应厂商编号                           */
icq02       varchar2(5) NOT NULL,    /*Wafer Site                             */
icq03       varchar2(80),            /*Wafer Site 说明                        */
icq04       varchar2(1),             /*标准码(不能重覆)                       */
icq05       varchar2(1),             /*no use                                 */
icq06       varchar2(1)              /*no use                                 */
);

create unique index icq_02 on icq_file (icq01,icq04);
alter table icq_file add  constraint icq_pk primary key  (icq01,icq02) enable validate;
grant select on icq_file to tiptopgp;
grant update on icq_file to tiptopgp;
grant delete on icq_file to tiptopgp;
grant insert on icq_file to tiptopgp;
grant index on icq_file to public;
grant select on icq_file to ods;
