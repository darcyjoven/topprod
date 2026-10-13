/*
================================================================================
檔案代號:ocr_file
檔案名稱:售货动作代号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ocr_file
(
ocr01       varchar2(10) DEFAULT ' ' NOT NULL, /*售货动作代号*/
ocr02       varchar2(80)             /*售货动作名称                           */
);

alter table ocr_file add  constraint ocr_pk primary key  (ocr01) enable validate;
grant select on ocr_file to tiptopgp;
grant update on ocr_file to tiptopgp;
grant delete on ocr_file to tiptopgp;
grant insert on ocr_file to tiptopgp;
grant index on ocr_file to public;
grant select on ocr_file to ods;
