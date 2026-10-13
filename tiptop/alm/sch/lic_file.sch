/*
================================================================================
檔案代號:lic_file
檔案名稱:摊位申请单单身一档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lic_file
(
lic01       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位申请单号*/
lic02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
lic03       varchar2(20) DEFAULT ' ' NOT NULL, /*场地编号*/
lic04       varchar2(10),            /*楼层编号                               */
lic05       varchar2(10),            /*区域编号                               */
lic06       number(20,6),            /*建筑面积                               */
lic07       number(20,6),            /*測量面積                               */
lic08       number(20,6),            /*经营面积                               */
licacti     varchar2(1) DEFAULT ' ' NOT NULL, /*有效否*/
liclegal    varchar2(10),            /*所属法人                               */
licplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table lic_file add  constraint lic_pk primary key  (lic01,lic03) enable validate;
grant select on lic_file to tiptopgp;
grant update on lic_file to tiptopgp;
grant delete on lic_file to tiptopgp;
grant insert on lic_file to tiptopgp;
grant index on lic_file to public;
grant select on lic_file to ods;
