/*
================================================================================
檔案代號:raf_file
檔案名稱:组合促销第一单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table raf_file
(
raf01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
raf02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
raf03       number(5) DEFAULT '0' NOT NULL, /*组别*/
raf04       varchar2(1) DEFAULT ' ' NOT NULL, /*参与方式*/1.必选，2可选*/
raf05       number(5) DEFAULT '0',   /*数量                                   */
rafacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
raflegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rafplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table raf_file add  constraint raf_pk primary key  (raf01,raf02,raf03,rafplant) enable validate;
grant select on raf_file to tiptopgp;
grant update on raf_file to tiptopgp;
grant delete on raf_file to tiptopgp;
grant insert on raf_file to tiptopgp;
grant index on raf_file to public;
grant select on raf_file to ods;
