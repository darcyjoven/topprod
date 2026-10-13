/*
================================================================================
檔案代號:llc_file
檔案名稱:招商门店参数单身二档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table llc_file
(
llc01       varchar2(10) DEFAULT ' ' NOT NULL, /*产品分类编号*/
llc02       number(5),               /*最大免租天數                           */
llc03       varchar2(1) DEFAULT ' ' NOT NULL, /*出賬時段*/
llclegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
llcstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table llc_file add  constraint llc_pk primary key  (llcstore,llc01) enable validate;
grant select on llc_file to tiptopgp;
grant update on llc_file to tiptopgp;
grant delete on llc_file to tiptopgp;
grant insert on llc_file to tiptopgp;
grant index on llc_file to public;
grant select on llc_file to ods;
