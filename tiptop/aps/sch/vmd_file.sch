/*
================================================================================
檔案代號:vmd_file
檔案名稱:aps 资源维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vmd_file
(
vmd01       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
vmd02       varchar2(60),            /*周行事历                               */
vmd03       varchar2(60),            /*日行事历                               */
vmd04       number(1),               /*产能类型                               */
vmd07       number(1),               /*连批条件检查码(1~5)                    */
vmd08       number(9,4) DEFAULT '0' NOT NULL /*机台效率*/
);

alter table vmd_file add  constraint vmd_pk primary key  (vmd01) enable validate;
grant select on vmd_file to tiptopgp;
grant update on vmd_file to tiptopgp;
grant delete on vmd_file to tiptopgp;
grant insert on vmd_file to tiptopgp;
grant index on vmd_file to public;
grant select on vmd_file to ods;
