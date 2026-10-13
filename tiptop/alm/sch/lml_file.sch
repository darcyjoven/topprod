/*
================================================================================
檔案代號:lml_file
檔案名稱:产品分类与摊位关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lml_file
(
lml01       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位编号*/
lml02       varchar2(10) DEFAULT ' ' NOT NULL, /*产品分类*/
lml03       varchar2(10),            /*no use                                 */
lml04       varchar2(10),            /*楼栋编号                               */
lml05       varchar2(10),            /*楼层编号                               */
lml06       varchar2(1),             /*有效否                                 */
lmllegal    varchar2(10) NOT NULL,   /*所属法人                               */
lmlstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lml_file add  constraint lml_pk primary key  (lml01,lml02) enable validate;
grant select on lml_file to tiptopgp;
grant update on lml_file to tiptopgp;
grant delete on lml_file to tiptopgp;
grant insert on lml_file to tiptopgp;
grant index on lml_file to public;
grant select on lml_file to ods;
