/*
================================================================================
檔案代號:odu_file
檔案名稱:产品配比维护作业单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odu_file
(
odu01       varchar2(10) DEFAULT ' ' NOT NULL, /*配比版本*/
odu02       varchar2(60),            /*配比说明                               */
odu03       varchar2(10),            /*适用产品类型                           */
odu04       varchar2(10),            /*适用销售区域                           */
oduacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
odudate     date,                    /*资料更改日                             */
odugrup     varchar2(10),            /*资料所有部门                           */
odumodu     varchar2(10),            /*资料更改者                             */
oduorig     varchar2(10),            /*资料建立部门                           */
oduoriu     varchar2(10),            /*资料建立者                             */
oduuser     varchar2(10)             /*资料所有者                             */
);

alter table odu_file add  constraint odu_pk primary key  (odu01) enable validate;
grant select on odu_file to tiptopgp;
grant update on odu_file to tiptopgp;
grant delete on odu_file to tiptopgp;
grant insert on odu_file to tiptopgp;
grant index on odu_file to public;
grant select on odu_file to ods;
