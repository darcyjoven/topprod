/*
================================================================================
檔案代號:rzh_file
檔案名稱:触屏分类资料档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table rzh_file
(
rzh01       varchar2(10) DEFAULT ' ' NOT NULL, /*触屏分类*/
rzh02       varchar2(40),            /*分类名称                               */
rzh03       number(5),               /*层级                                   */
rzh04       varchar2(10),            /*上级分类                               */
rzh05       number(5),               /*下级分类数                             */
rzh06       varchar2(10),            /*所属一级分类                           */
rzhacti     varchar2(1) DEFAULT ' ' NOT NULL /*资料有效码*/
);

alter table rzh_file add  constraint rzh_pk primary key  (rzh01) enable validate;
grant select on rzh_file to tiptopgp;
grant update on rzh_file to tiptopgp;
grant delete on rzh_file to tiptopgp;
grant insert on rzh_file to tiptopgp;
grant index on rzh_file to public;
grant select on rzh_file to ods;
