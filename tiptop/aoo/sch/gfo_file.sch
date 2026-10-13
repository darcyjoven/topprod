/*
================================================================================
檔案代號:gfo_file
檔案名稱:量化單位基本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table gfo_file
(
gfo01       varchar2(4) DEFAULT ' ' NOT NULL, /*量化單位*/
gfo02       varchar2(80),            /*说明                                   */
gfoacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
gfodate     date,                    /*最近更改日                             */
gfogrup     varchar2(10),            /*资料所有群                             */
gfomodu     varchar2(10),            /*资料更改者                             */
gfoorig     varchar2(10),            /*资料建立部门                           */
gfooriu     varchar2(10),            /*资料建立者                             */
gfouser     varchar2(10)             /*资料所有者                             */
);

alter table gfo_file add  constraint gfo_pk primary key  (gfo01) enable validate;
grant select on gfo_file to tiptopgp;
grant update on gfo_file to tiptopgp;
grant delete on gfo_file to tiptopgp;
grant insert on gfo_file to tiptopgp;
grant index on gfo_file to public;
grant select on gfo_file to ods;
