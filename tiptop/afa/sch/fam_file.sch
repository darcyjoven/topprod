/*
================================================================================
檔案代號:fam_file
檔案名稱:固定资产备注档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fam_file
(
fam00       varchar2(1) NOT NULL,    /*类型                                   */
fam01       varchar2(20) NOT NULL,   /*单据号码/财产编号                      */
fam02       number(5) NOT NULL,      /*项次                                   */
fam03       number(5) NOT NULL,      /*行序                                   */
fam04       varchar2(1),             /*打印码                                 */
fam05       varchar2(255)            /*备注                                   */
);

alter table fam_file add  constraint fam_pk primary key  (fam00,fam01,fam02,fam03) enable validate;
grant select on fam_file to tiptopgp;
grant update on fam_file to tiptopgp;
grant delete on fam_file to tiptopgp;
grant insert on fam_file to tiptopgp;
grant index on fam_file to public;
grant select on fam_file to ods;
