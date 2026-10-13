/*
================================================================================
檔案代號:bmk_file
檔案名稱:料件机种维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bmk_file
(
bmk01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
bmk02       number(5) NOT NULL,      /*行序                                   */
bmk03       varchar2(5)              /*机种编号                               */
                                     /*機種代號                               */
);

alter table bmk_file add  constraint bmk_pk primary key  (bmk01,bmk02) enable validate;
grant select on bmk_file to tiptopgp;
grant update on bmk_file to tiptopgp;
grant delete on bmk_file to tiptopgp;
grant insert on bmk_file to tiptopgp;
grant index on bmk_file to public;
grant select on bmk_file to ods;
