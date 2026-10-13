/*
================================================================================
檔案代號:lmh_file
檔案名稱:场地摊位关系单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmh_file
(
lmh01       varchar2(20) DEFAULT ' ' NOT NULL, /*场地摊位关系单号*/
lmh02       varchar2(20),            /*摊位编号                               */
lmh03       varchar2(20) DEFAULT ' ' NOT NULL, /*场地编号*/
lmh04       number(20,2),            /*经营面积                               */
lmh05       number(20,2),            /*建筑面积                               */
lmh06       varchar2(1),             /*此场摊关系有效否                       */
lmh07       varchar2(10),            /*no use                                 */
lmhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lmhstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lmh_file add  constraint lmh_pk primary key  (lmh01,lmh03) enable validate;
grant select on lmh_file to tiptopgp;
grant update on lmh_file to tiptopgp;
grant delete on lmh_file to tiptopgp;
grant insert on lmh_file to tiptopgp;
grant index on lmh_file to public;
grant select on lmh_file to ods;
