/*
================================================================================
檔案代號:gfm_file
檔案名稱:动态图表可用属性配置文件
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gfm_file
(
gfm01       varchar2(30) DEFAULT ' ' NOT NULL, /*图表名称*/
gfm02       varchar2(1) DEFAULT ' ' NOT NULL, /*图表类型*/
gfm03       varchar2(50) DEFAULT ' ' NOT NULL, /*属性名称*/
gfm04       varchar2(255) DEFAULT ' ' NOT NULL, /*属性说明*/
gfm05       varchar2(1) DEFAULT ' ' NOT NULL, /*属性类型*/
gfm06       varchar2(255) DEFAULT ' ' NOT NULL, /*属性缺省值*/
gfm07       varchar2(1) DEFAULT ' '  /*No use                                 */
);

alter table gfm_file add  constraint gfm_pk primary key  (gfm01,gfm02,gfm03) enable validate;
grant select on gfm_file to tiptopgp;
grant update on gfm_file to tiptopgp;
grant delete on gfm_file to tiptopgp;
grant insert on gfm_file to tiptopgp;
grant index on gfm_file to public;
grant select on gfm_file to ods;
