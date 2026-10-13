/*
================================================================================
檔案代號:gdk_file
檔案名稱:自定义图表列表文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdk_file
(
gdk01       varchar2(30) DEFAULT ' ' NOT NULL, /*图表名称*/
gdk02       varchar2(10),            /*优先顺序                               */
gdk03       varchar2(10),            /*显示频率                               */
gdkdate     date,                    /*最近更改日                             */
gdkgrup     varchar2(10),            /*资料所有群                             */
gdkmodu     varchar2(10),            /*资料更改者                             */
gdkorig     varchar2(10),            /*资料建立部门                           */
gdkoriu     varchar2(10),            /*资料建立者                             */
gdkuser     varchar2(10)             /*资料所有者                             */
);

alter table gdk_file add  constraint gdk_pk primary key  (gdk01) enable validate;
grant select on gdk_file to tiptopgp;
grant update on gdk_file to tiptopgp;
grant delete on gdk_file to tiptopgp;
grant insert on gdk_file to tiptopgp;
grant index on gdk_file to public;
grant select on gdk_file to ods;
