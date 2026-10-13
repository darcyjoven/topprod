/*
================================================================================
檔案代號:sld_file
檔案名稱:成品尺寸表档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sld_file
(
sld01       varchar2(10) DEFAULT ' ' NOT NULL, /*制单号*/
sld02       varchar2(20) DEFAULT ' ' NOT NULL, /*款式号*/
sld03       number(5) DEFAULT '0' NOT NULL, /*项次*/
sld04       varchar2(4),             /*部位顺序                               */
sld05       varchar2(10),            /*部位                                   */
sld06       varchar2(10),            /*度法                                   */
sld07       varchar2(1),             /*布纹                                   */
sld08       varchar2(10) DEFAULT ' ' NOT NULL, /*尺码*/
sld09       varchar2(10),            /*洗前尺寸分                             */
sld09a      number(15,3),            /*洗前尺寸小                             */
sld10       varchar2(10),            /*公差                                   */
sld11       varchar2(255),           /*備注                                   */
sld12       number(15,3),            /*成品尺寸分                             */
sld12a      number(15,3)             /*成品尺寸大小                           */
);

alter table sld_file add  constraint sld_pk primary key  (sld01,sld02,sld03,sld08) enable validate;
grant select on sld_file to tiptopgp;
grant update on sld_file to tiptopgp;
grant delete on sld_file to tiptopgp;
grant insert on sld_file to tiptopgp;
grant index on sld_file to public;
grant select on sld_file to ods;
