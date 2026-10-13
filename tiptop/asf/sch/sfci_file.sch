/*
================================================================================
檔案代號:sfci_file
檔案名稱:料表批号主档(行业别架构)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sfci_file
(
sfci01      varchar2(20) DEFAULT ' ' NOT NULL, /*料表批号  (pbi number)储存合并  */
sfcislk01   varchar2(20),            /*制单号 行业别字段                      */
sfcislk02   date,                    /*预计齐料日                             */
sfcislk03   date,                    /*实际齐料日                             */
sfcislk04   varchar2(1),             /*是否版单                               */
sfcislk05   varchar2(1)              /*审核码                                 */
);

alter table sfci_file add  constraint sfci_pk primary key  (sfci01) enable validate;
grant select on sfci_file to tiptopgp;
grant update on sfci_file to tiptopgp;
grant delete on sfci_file to tiptopgp;
grant insert on sfci_file to tiptopgp;
grant index on sfci_file to public;
grant select on sfci_file to ods;
