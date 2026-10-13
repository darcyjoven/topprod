/*
================================================================================
檔案代號:gff_file
檔案名稱:编码年对照表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gff_file
(
gff01       number(5) NOT NULL,      /*年                                     */
gff02       number(5) NOT NULL,      /*长度                                   */
gff03       varchar2(10)             /*编码编号                               */
);

alter table gff_file add  constraint gff_pk primary key  (gff01,gff02) enable validate;
grant select on gff_file to tiptopgp;
grant update on gff_file to tiptopgp;
grant delete on gff_file to tiptopgp;
grant insert on gff_file to tiptopgp;
grant index on gff_file to public;
grant select on gff_file to ods;
