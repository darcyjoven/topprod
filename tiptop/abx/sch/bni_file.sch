/*
================================================================================
檔案代號:bni_file
檔案名稱:保税BOM编号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bni_file
(
bni01       varchar2(20) NOT NULL,   /*BOM编号字首                            */
bni02       varchar2(4) NOT NULL,    /*BOM编号流水号                          */
bni03       varchar2(4) NOT NULL     /*BOM编号字尾                            */
);

alter table bni_file add  constraint bni_pk primary key  (bni01,bni02,bni03) enable validate;
grant select on bni_file to tiptopgp;
grant update on bni_file to tiptopgp;
grant delete on bni_file to tiptopgp;
grant insert on bni_file to tiptopgp;
grant index on bni_file to public;
grant select on bni_file to ods;
