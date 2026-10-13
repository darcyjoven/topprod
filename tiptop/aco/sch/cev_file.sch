/*
================================================================================
檔案代號:cev_file
檔案名稱:海关经营商品大类档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cev_file
(
cev01       varchar2(10) DEFAULT ' ' NOT NULL, /*商品大类编号*/
cev02       varchar2(80),            /*商品大类名称                           */
cev03       number(5),               /*商品大类归并序号                       */
cevacti     varchar2(1),             /*资料有效码                             */
cevdate     date,                    /*最近更改日                             */
cevgrup     varchar2(10),            /*资料所有部门                           */
cevmodu     varchar2(10),            /*资料更改者                             */
cevuser     varchar2(10),            /*资料所有者                             */
cevorig     varchar2(10),            /*资料建立部门                           */
cevoriu     varchar2(10)             /*资料建立者                             */
);

alter table cev_file add  constraint cev_pk primary key  (cev01) enable validate;
grant select on cev_file to tiptopgp;
grant update on cev_file to tiptopgp;
grant delete on cev_file to tiptopgp;
grant insert on cev_file to tiptopgp;
grant index on cev_file to public;
grant select on cev_file to ods;
