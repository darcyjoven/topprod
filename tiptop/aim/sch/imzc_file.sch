/*
================================================================================
檔案代號:imzc_file
檔案名稱:分群码料件特性基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imzc_file
(
imzc01      varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
imzc02      number(5) DEFAULT '0' NOT NULL, /*项次*/
imzc03      varchar2(1),             /*归属层级                               */
imzc04      varchar2(10),            /*特性代码                               */
imzc05      varchar2(40),            /*特性值                                 */
imzcdate    date,                    /*最近更改日                             */
imzcgrup    varchar2(10),            /*资料所有部门                           */
imzcmodu    varchar2(10),            /*资料更改者                             */
imzcorig    varchar2(10),            /*资料建立部门                           */
imzcoriu    varchar2(10),            /*资料建立者                             */
imzcuser    varchar2(10)             /*资料所有者                             */
);

alter table imzc_file add  constraint imzc_pk primary key  (imzc01,imzc02) enable validate;
grant select on imzc_file to tiptopgp;
grant update on imzc_file to tiptopgp;
grant delete on imzc_file to tiptopgp;
grant insert on imzc_file to tiptopgp;
grant index on imzc_file to public;
grant select on imzc_file to ods;
