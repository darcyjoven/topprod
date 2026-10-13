/*
================================================================================
檔案代號:gdf_file
檔案名稱:背景作业单身纪录文件
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdf_file
(
gdf01       varchar2(40) DEFAULT ' ' NOT NULL, /*作业名称*/
gdf02       number(5) DEFAULT '0' NOT NULL, /*序号*/
gdf03       varchar2(20),            /*程序代码                               */
gdf04       varchar2(10),            /*营运中心                               */
gdf05       varchar2(1000),          /*收件者                                 */
gdf06       varchar2(1000),          /*副本                                   */
gdf07       varchar2(1000),          /*密件副本                               */
gdf08       varchar2(10) DEFAULT ' ' NOT NULL
);

alter table gdf_file add  constraint gdf_pk primary key  (gdf01,gdf02,gdf08) enable validate;
grant select on gdf_file to tiptopgp;
grant update on gdf_file to tiptopgp;
grant delete on gdf_file to tiptopgp;
grant insert on gdf_file to tiptopgp;
grant index on gdf_file to public;
grant select on gdf_file to ods;
