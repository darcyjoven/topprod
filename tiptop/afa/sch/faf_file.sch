/*
================================================================================
檔案代號:faf_file
檔案名稱:固定资产存放位置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table faf_file
(
faf01       varchar2(10) NOT NULL,   /*存放位置代码                           */
faf02       varchar2(80),            /*存放位置名称                           */
faf03       varchar2(10),            /*存放营运中心                           */
fafacti     varchar2(1),             /*资料有效码                             */
fafuser     varchar2(10),            /*资料所有者                             */
fafgrup     varchar2(10),            /*资料所有群                             */
fafmodu     varchar2(10),            /*资料更改者                             */
fafdate     date,                    /*最近更改日                             */
faforig     varchar2(10),            /*资料建立部门                           */
faforiu     varchar2(10)             /*资料建立者                             */
);

alter table faf_file add  constraint faf_pk primary key  (faf01) enable validate;
grant select on faf_file to tiptopgp;
grant update on faf_file to tiptopgp;
grant delete on faf_file to tiptopgp;
grant insert on faf_file to tiptopgp;
grant index on faf_file to public;
grant select on faf_file to ods;
