/*
================================================================================
檔案代號:fjc_file
檔案名稱:设备保修项目资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fjc_file
(
fjc01       varchar2(20) NOT NULL,   /*设备编号                               */
fjc02       number(5) NOT NULL,      /*项次                                   */
fjc03       varchar2(10),            /*保修类型                               */
fjc04       varchar2(1),             /*保养周期                               */
fjc05       varchar2(2),             /*保修规模                               */
fjc06       varchar2(1)              /*停机否                                 */
);

alter table fjc_file add  constraint fjc_pk primary key  (fjc01,fjc02) enable validate;
grant select on fjc_file to tiptopgp;
grant update on fjc_file to tiptopgp;
grant delete on fjc_file to tiptopgp;
grant insert on fjc_file to tiptopgp;
grant index on fjc_file to public;
grant select on fjc_file to ods;
