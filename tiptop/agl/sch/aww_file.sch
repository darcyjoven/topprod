/*
================================================================================
檔案代號:aww_file
檔案名稱:部门归属档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aww_file
(
aww01       number(5) NOT NULL,      /*年度                                   */
aww02       varchar2(1) NOT NULL,    /*部门分类型                             */
aww03       varchar2(10) NOT NULL,   /*归属部门                               */
aww04       varchar2(10) NOT NULL,   /*明细部门                               */
awwacti     varchar2(1),             /*资料有效码                             */
awwuser     varchar2(10),            /*资料所有者                             */
awwgrup     varchar2(10),            /*资料所有群                             */
awwmodu     varchar2(10),            /*资料更改者                             */
awwdate     date,                    /*最近更改日                             */
awworig     varchar2(10),            /*资料建立部门                           */
awworiu     varchar2(10)             /*资料建立者                             */
);

alter table aww_file add  constraint aww_pk primary key  (aww01,aww02,aww03,aww04) enable validate;
grant select on aww_file to tiptopgp;
grant update on aww_file to tiptopgp;
grant delete on aww_file to tiptopgp;
grant insert on aww_file to tiptopgp;
grant index on aww_file to public;
grant select on aww_file to ods;
