/*
================================================================================
檔案代號:gaq_file
檔案名稱:字段多语言说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gaq_file
(
gaq01       varchar2(20) NOT NULL,   /*字段代码                               */
gaq02       varchar2(1) NOT NULL,    /*语言别                                 */
gaq03       varchar2(255),           /*字段名称                               */
gaq04       varchar2(500),           /*字段说明                               */
gaq05       varchar2(2000),          /*额外说明                               */
gaq06       varchar2(1),             /*Unicode放大                            */
gaq07       varchar2(3),             /*字段属性注记                           */
gaq08       date                     /*异动日期                               */
);

alter table gaq_file add  constraint gaq_pk primary key  (gaq01,gaq02) enable validate;
grant select on gaq_file to tiptopgp;
grant update on gaq_file to tiptopgp;
grant delete on gaq_file to tiptopgp;
grant insert on gaq_file to tiptopgp;
grant index on gaq_file to public;
grant select on gaq_file to ods;
