/*
================================================================================
檔案代號:wsi_file
檔案名稱:easyflow 集成设置档(字段关连设置)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsi_file
(
wsi01       varchar2(20) NOT NULL,   /*程序编号                               */
wsi02       varchar2(20) NOT NULL,   /*字段名称                               */
wsi03       varchar2(15) NOT NULL,   /*参考字段的 table 名称                  */
wsi04       varchar2(20) NOT NULL,   /*参考字段的 key 值字段名称              */
wsi05       varchar2(20) NOT NULL,   /*被关连的 column 名称                   */
wsi06       varchar2(255),           /*其他额外条件                           */
wsi07       varchar2(10),            /*No Use                                 */
wsi08       varchar2(10),            /*No Use                                 */
wsi09       varchar2(10),            /*No Use                                 */
wsi10       varchar2(10)             /*No Use                                 */
);

alter table wsi_file add  constraint wsi_pk primary key  (wsi01,wsi02,wsi05) enable validate;
grant select on wsi_file to tiptopgp;
grant update on wsi_file to tiptopgp;
grant delete on wsi_file to tiptopgp;
grant insert on wsi_file to tiptopgp;
grant index on wsi_file to public;
grant select on wsi_file to ods;
