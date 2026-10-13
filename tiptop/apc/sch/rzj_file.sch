/*
================================================================================
檔案代號:rzj_file
檔案名稱:POS触屏分类资料档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table rzj_file
(
rzj01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
rzj02       varchar2(1) DEFAULT ' ' NOT NULL, /*分类类型 1:大类 2:小类*/
rzj03       varchar2(10) DEFAULT ' ' NOT NULL, /*分类编号*/
rzj04       varchar2(40),            /*分类名称                               */
rzj05       varchar2(10),            /*上级分类                               */
rzj06       number(5),               /*顺序号                                 */
rzjacti     varchar2(1) DEFAULT ' ' NOT NULL /*资料有效码*/
);

alter table rzj_file add  constraint rzj_pk primary key  (rzj01,rzj03) enable validate;
grant select on rzj_file to tiptopgp;
grant update on rzj_file to tiptopgp;
grant delete on rzj_file to tiptopgp;
grant insert on rzj_file to tiptopgp;
grant index on rzj_file to public;
grant select on rzj_file to ods;
