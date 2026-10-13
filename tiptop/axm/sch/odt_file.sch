/*
================================================================================
檔案代號:odt_file
檔案名稱:企业产品结构档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odt_file
(
odt01       varchar2(10) DEFAULT ' ' NOT NULL, /*结构编号*/
odt02       varchar2(100),           /*结构说明                               */
odt03       varchar2(10) DEFAULT ' ' NOT NULL, /*上级分类*/
odt04       varchar2(10) DEFAULT ' ' NOT NULL, /*类型*/
odt05       number(15,3) DEFAULT '0' NOT NULL, /*占比%*/
odt06       number(15,3) DEFAULT '0' NOT NULL, /*占量*/
odt07       varchar2(10),            /*编码类型                               */
odtacti     varchar2(1),             /*资料有效码                             */
odtdate     date,                    /*最近更改日                             */
odtgrup     varchar2(10),            /*资料所有部门                           */
odtmodu     varchar2(10),            /*资料更改者                             */
odtorig     varchar2(10),            /*资料建立部门                           */
odtoriu     varchar2(10),            /*资料建立者                             */
odtuser     varchar2(10)             /*资料所有者                             */
);

alter table odt_file add  constraint odt_pk primary key  (odt01,odt03,odt04) enable validate;
grant select on odt_file to tiptopgp;
grant update on odt_file to tiptopgp;
grant delete on odt_file to tiptopgp;
grant insert on odt_file to tiptopgp;
grant index on odt_file to public;
grant select on odt_file to ods;
