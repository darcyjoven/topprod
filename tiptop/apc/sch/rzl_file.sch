/*
================================================================================
檔案代號:rzl_file
檔案名稱:POS触屏方案生效范围档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table rzl_file
(
rzl01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
rzl02       varchar2(10) DEFAULT ' ' NOT NULL, /*生效门店*/
rzlacti     varchar2(1) NOT NULL     /*资料有效码                             */
);

alter table rzl_file add  constraint rzl_pk primary key  (rzl01,rzl02) enable validate;
grant select on rzl_file to tiptopgp;
grant update on rzl_file to tiptopgp;
grant delete on rzl_file to tiptopgp;
grant insert on rzl_file to tiptopgp;
grant index on rzl_file to public;
grant select on rzl_file to ods;
