/*
================================================================================
檔案代號:tqc_file
檔案名稱:集团组织机构单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqc_file
(
tqc01       varchar2(10) NOT NULL,   /*上级组织编号                           */
tqc02       date,                    /*生效日期                               */
tqc03       date,                    /*实效日期                               */
tqcacti     varchar2(1),             /*资料有效否                             */
tqcuser     varchar2(10),            /*资料所有者                             */
tqcgrup     varchar2(10),            /*资料所有群                             */
tqcmodu     varchar2(10),            /*资料更改者                             */
tqcdate     date,                    /*最近更改日期                           */
tqcoriu     varchar2(10),            /*资料建立者                             */
tqcorig     varchar2(10)             /*资料建立部门                           */
);

alter table tqc_file add  constraint tqc_pk primary key  (tqc01) enable validate;
grant select on tqc_file to tiptopgp;
grant update on tqc_file to tiptopgp;
grant delete on tqc_file to tiptopgp;
grant insert on tqc_file to tiptopgp;
grant index on tqc_file to public;
grant select on tqc_file to ods;
