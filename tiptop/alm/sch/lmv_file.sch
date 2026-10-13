/*
================================================================================
檔案代號:lmv_file
檔案名稱:商户商品数据关联档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmv_file
(
lmv01       varchar2(10) DEFAULT ' ' NOT NULL, /*商户号*/
lmv02       varchar2(40) DEFAULT ' ' NOT NULL, /*产品编号*/
lmvacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
lmvpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
lmv03       varchar2(20) DEFAULT ' ' NOT NULL /*摊位编号*/
);

alter table lmv_file add  constraint lmv_pk primary key  (lmv01,lmv02,lmv03) enable validate;
grant select on lmv_file to tiptopgp;
grant update on lmv_file to tiptopgp;
grant delete on lmv_file to tiptopgp;
grant insert on lmv_file to tiptopgp;
grant index on lmv_file to public;
grant select on lmv_file to ods;
