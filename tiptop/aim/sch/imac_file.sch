/*
================================================================================
檔案代號:imac_file
檔案名稱:料件特性基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imac_file
(
imac01      varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
imac02      number(5) DEFAULT '0' NOT NULL, /*项次*/
imac03      varchar2(1) DEFAULT ' ' NOT NULL, /*归属层级*/
imac04      varchar2(10),            /*特性代码                               */
imac05      varchar2(40),
imacdate    date,                    /*最近更改日                             */
imacgrup    varchar2(10),            /*资料所有群                             */
imacmodu    varchar2(10),            /*资料更改者                             */
imacorig    varchar2(10),            /*资料建立部门                           */
imacoriu    varchar2(10),            /*资料建立者                             */
imacuser    varchar2(10)             /*资料所有者                             */
);

alter table imac_file add  constraint imac_pk primary key  (imac01,imac02) enable validate;
grant select on imac_file to tiptopgp;
grant update on imac_file to tiptopgp;
grant delete on imac_file to tiptopgp;
grant insert on imac_file to tiptopgp;
grant index on imac_file to public;
grant select on imac_file to ods;
