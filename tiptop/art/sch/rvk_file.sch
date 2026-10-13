/*
================================================================================
檔案代號:rvk_file
檔案名稱:配送分货仓库资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rvk_file
(
rvk01       varchar2(10) DEFAULT ' ' NOT NULL, /*配送中心*/
rvk02       varchar2(10) DEFAULT ' ' NOT NULL, /*产品分类*/
rvk03       varchar2(10),            /*分货仓库                               */
rvk04       varchar2(10) DEFAULT ' ' NOT NULL, /*需求营运中心*/
rvkacti     varchar2(1),             /*资料有效码                             */
rvkcrat     date,                    /*资料创建日                             */
rvkdate     date,                    /*最近更改日                             */
rvkgrup     varchar2(10),            /*资料所有部门                           */
rvkmodu     varchar2(10),            /*资料更改者                             */
rvkuser     varchar2(10),            /*资料所有者                             */
rvkorig     varchar2(10),            /*资料建立部门                           */
rvkoriu     varchar2(10)             /*资料建立者                             */
);

alter table rvk_file add  constraint rvk_pk primary key  (rvk01,rvk02,rvk04) enable validate;
grant select on rvk_file to tiptopgp;
grant update on rvk_file to tiptopgp;
grant delete on rvk_file to tiptopgp;
grant insert on rvk_file to tiptopgp;
grant index on rvk_file to public;
grant select on rvk_file to ods;
