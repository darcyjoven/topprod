/*
================================================================================
檔案代號:eck_file
檔案名稱:资源耗损系数资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table eck_file
(
eck00       varchar2(1) DEFAULT '1' NOT NULL, /*类别(1:料号 2:分群码)*/
eck01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号/分群码*/
eck02       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
eck03       varchar2(10) DEFAULT ' ' NOT NULL, /*作业编号*/
eck04       number(15,3) DEFAULT '0' NOT NULL, /*起始数量*/
eck05       number(15,3) DEFAULT '0' NOT NULL, /*截止数量*/
eck06       number(9,4),             /*固定损耗系数                           */
eck07       number(9,4),             /*变动损耗系数                           */
eckacti     varchar2(1),             /*资料有效码                             */
eckdate     date,                    /*最近更改日                             */
eckgrup     varchar2(10),            /*资料所有群                             */
eckmodu     varchar2(10),            /*资料更改者                             */
eckorig     varchar2(10),            /*资料建立部门                           */
eckoriu     varchar2(10),            /*资料建立者                             */
eckuser     varchar2(10)             /*资料所有者                             */
);

alter table eck_file add  constraint eck_pk primary key  (eck00,eck01,eck02,eck03,eck04,eck05) enable validate;
grant select on eck_file to tiptopgp;
grant update on eck_file to tiptopgp;
grant delete on eck_file to tiptopgp;
grant insert on eck_file to tiptopgp;
grant index on eck_file to public;
grant select on eck_file to ods;
