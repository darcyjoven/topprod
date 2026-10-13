/*
================================================================================
檔案代號:tqf_file
檔案名稱:渠道关系单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqf_file
(
tqf01       varchar2(10) NOT NULL,   /*上级通路代码                           */
tqf02       date,                    /*生效日期                               */
tqf03       date,                    /*失效日期                               */
tqfacti     varchar2(1),             /*资料有效否                             */
tqfuser     varchar2(10),            /*资料所有者                             */
tqfgrup     varchar2(10),            /*资料所有群                             */
tqfmodu     varchar2(10),            /*资料更改者                             */
tqfdate     date,                    /*最近更改日期                           */
tqforig     varchar2(10),            /*资料建立部门                           */
tqforiu     varchar2(10)             /*资料建立者                             */
);

alter table tqf_file add  constraint tqf_pk primary key  (tqf01) enable validate;
grant select on tqf_file to tiptopgp;
grant update on tqf_file to tiptopgp;
grant delete on tqf_file to tiptopgp;
grant insert on tqf_file to tiptopgp;
grant index on tqf_file to public;
grant select on tqf_file to ods;
