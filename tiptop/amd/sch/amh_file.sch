/*
================================================================================
檔案代號:amh_file
檔案名稱:店别代码建立作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table amh_file
(
amh01       varchar2(10) DEFAULT ' ' NOT NULL, /*总店号*/
amh02       varchar2(10) DEFAULT ' ' NOT NULL, /*分类方式*/
amh03       varchar2(255),           /*备注                                   */
amh04       varchar2(10) DEFAULT ' ' NOT NULL, /*店别编号*/
amh05       varchar2(10) DEFAULT ' ' NOT NULL, /*产品编号类别编号*/
amh06       varchar2(13),            /*对应店别编号                           */
amh07       varchar2(20),            /*供应商编号                             */
amhacti     varchar2(1) DEFAULT 'Y' NOT NULL /*资料有效码*/
);

alter table amh_file add  constraint amh_pk primary key  (amh01,amh02,amh04,amh05) enable validate;
grant select on amh_file to tiptopgp;
grant update on amh_file to tiptopgp;
grant delete on amh_file to tiptopgp;
grant insert on amh_file to tiptopgp;
grant index on amh_file to public;
grant select on amh_file to ods;
