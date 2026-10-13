/*
================================================================================
檔案代號:tna_file
檔案名稱:历年主会计账套档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tna_file
(
tna00       varchar2(1) NOT NULL,    /*类型                                   */
                                     /*0.Finacial Account 1.Management Account*/
tna01       number(5) NOT NULL,      /*年度                                   */
tna02       varchar2(5)              /*帐套                                   */
);

alter table tna_file add  constraint tna_pk primary key  (tna00,tna01) enable validate;
grant select on tna_file to tiptopgp;
grant update on tna_file to tiptopgp;
grant delete on tna_file to tiptopgp;
grant insert on tna_file to tiptopgp;
grant index on tna_file to public;
grant select on tna_file to ods;
