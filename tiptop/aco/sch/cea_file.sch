/*
================================================================================
檔案代號:cea_file
檔案名稱:监管方式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cea_file
(
cea01       varchar2(10) DEFAULT ' ' NOT NULL, /*监管方式代号*/
cea02       varchar2(80),            /*监管方式名称                           */
ceaacti     varchar2(1),             /*资料有效码                             */
ceadate     date,                    /*最近更改日                             */
ceagrup     varchar2(10),            /*资料所有部门                           */
ceamodu     varchar2(10),            /*资料更改者                             */
ceauser     varchar2(10),            /*资料所有者                             */
ceaorig     varchar2(10),            /*资料建立部门                           */
ceaoriu     varchar2(10)             /*资料建立者                             */
);

alter table cea_file add  constraint cea_pk primary key  (cea01) enable validate;
grant select on cea_file to tiptopgp;
grant update on cea_file to tiptopgp;
grant delete on cea_file to tiptopgp;
grant insert on cea_file to tiptopgp;
grant index on cea_file to public;
grant select on cea_file to ods;
