/*
================================================================================
檔案代號:lmi_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmi_file
(
lmi01       varchar2(10) DEFAULT ' ' NOT NULL, /*大类编号*/
lmi02       varchar2(60),            /*大类名称                               */
lmi03       varchar2(1)              /*有效否                                 */
);

alter table lmi_file add  constraint lmi_pk primary key  (lmi01) enable validate;
grant select on lmi_file to tiptopgp;
grant update on lmi_file to tiptopgp;
grant delete on lmi_file to tiptopgp;
grant insert on lmi_file to tiptopgp;
grant index on lmi_file to public;
grant select on lmi_file to ods;
