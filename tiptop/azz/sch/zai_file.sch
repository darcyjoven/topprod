/*
================================================================================
檔案代號:zai_file
檔案名稱:自定义查询设置主页
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zai_file
(
zai01       varchar2(80) NOT NULL,   /*查询单ID                               */
zai02       varchar2(255),           /*查询单名称                             */
zai03       varchar2(255),           /*说明                                   */
zaiuser     varchar2(10),            /*资料所有者                             */
zaigrup     varchar2(10),            /*资料所有群                             */
zaimodu     varchar2(10),            /*资料更改者                             */
zaidate     date,                    /*最近更改日                             */
zai04       varchar2(1),             /*查詢報表時是否需錄入查詢條             */
zai05       varchar2(1) NOT NULL,    /*客制码                                 */
zai06       varchar2(1),             /*是否提供进阶查询选项                   */
zai07       varchar2(20),            /*对应程序编号                           */
zaiorig     varchar2(10),            /*资料建立部门                           */
zaioriu     varchar2(10),            /*资料建立者                             */
zaiud01     varchar2(1),
zaiud02     varchar2(1),
zaiud03     varchar2(20),
zaiud04     varchar2(20),
zaiud05     varchar2(20),
zaiud06     number(15,3),
zaiud07     number(15,3),
zaiud08     number(15,3),
zaiud09     date,
zaiud10     date
);

alter table zai_file add  constraint zai_pk primary key  (zai01,zai05) enable validate;
grant select on zai_file to tiptopgp;
grant update on zai_file to tiptopgp;
grant delete on zai_file to tiptopgp;
grant insert on zai_file to tiptopgp;
grant index on zai_file to public;
grant select on zai_file to ods;
