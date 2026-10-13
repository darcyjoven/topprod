/*
================================================================================
檔案代號:fiz_file
檔案名稱:备件类型档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fiz_file
(
fiz01       varchar2(4) NOT NULL,    /*备件类型编号                           */
fiz02       varchar2(80)             /*说明                                   */
);

alter table fiz_file add  constraint fiz_pk primary key  (fiz01) enable validate;
grant select on fiz_file to tiptopgp;
grant update on fiz_file to tiptopgp;
grant delete on fiz_file to tiptopgp;
grant insert on fiz_file to tiptopgp;
grant index on fiz_file to public;
grant select on fiz_file to ods;
