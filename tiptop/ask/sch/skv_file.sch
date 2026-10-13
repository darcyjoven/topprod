/*
================================================================================
檔案代號:skv_file
檔案名稱:款式预算表
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table skv_file
(
skv01       varchar2(20) DEFAULT ' ' NOT NULL, /*制单号*/
skv02       varchar2(20) DEFAULT ' ' NOT NULL, /*款式号*/
skv03       number(5) DEFAULT '0' NOT NULL, /*项次*/
skv04       varchar2(10),
skv05       varchar2(10) DEFAULT ' ' NOT NULL, /*尺寸*/
skv06       varchar2(20) DEFAULT ' ' NOT NULL, /*内长*/
skv07       varchar2(20),
skv08       number(15,3),
skv09       number(5),               /*张数                                   */
skv10       number(5),               /*件数                                   */
skv11       number(15,3),
skv12       number(5),
skv13       varchar2(40),
skvplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skvlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table skv_file add  constraint skv_pk primary key  (skv01,skv02,skv03,skv05) enable validate;
grant select on skv_file to tiptopgp;
grant update on skv_file to tiptopgp;
grant delete on skv_file to tiptopgp;
grant insert on skv_file to tiptopgp;
grant index on skv_file to public;
grant select on skv_file to ods;
