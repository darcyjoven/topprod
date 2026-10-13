/*
================================================================================
檔案代號:tc_zai_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_zai_file
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
zaioriu     varchar2(10)             /*资料建立者                             */
);

grant select on tc_zai_file to tiptopgp;
grant update on tc_zai_file to tiptopgp;
grant delete on tc_zai_file to tiptopgp;
grant insert on tc_zai_file to tiptopgp;
grant index on tc_zai_file to public;
grant select on tc_zai_file to ods;
