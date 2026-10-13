/*
================================================================================
檔案代號:llb_file
檔案名稱:招商门店参数单身一档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table llb_file
(
llb01       varchar2(10) DEFAULT ' ' NOT NULL, /*费用编号*/
llb02       number(5),               /*退款推遲月                             */
llblegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
llbstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table llb_file add  constraint llb_pk primary key  (llbstore,llb01) enable validate;
grant select on llb_file to tiptopgp;
grant update on llb_file to tiptopgp;
grant delete on llb_file to tiptopgp;
grant insert on llb_file to tiptopgp;
grant index on llb_file to public;
grant select on llb_file to ods;
