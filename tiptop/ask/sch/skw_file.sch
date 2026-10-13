/*
================================================================================
檔案代號:skw_file
檔案名稱:裁剪预算档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table skw_file
(
skw01       varchar2(20) DEFAULT ' ' NOT NULL, /*制单号*/
skw02       varchar2(20) DEFAULT ' ' NOT NULL, /*款式号*/
skw03       number(5) DEFAULT '0' NOT NULL, /*项次*/
skw04       varchar2(20) DEFAULT ' ' NOT NULL, /*出口国*/
skw05       varchar2(20) DEFAULT ' ' NOT NULL, /*内长*/
skw06       varchar2(10) DEFAULT ' ' NOT NULL, /*尺寸*/
skw07       number(15,3),
skw08       varchar2(6),             /*颜色编号                               */
skw09       varchar2(10),            /*no use                                 */
skwplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skwlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table skw_file add  constraint skw_pk primary key  (skw01,skw02,skw03,skw04,skw05,skw06) enable validate;
grant select on skw_file to tiptopgp;
grant update on skw_file to tiptopgp;
grant delete on skw_file to tiptopgp;
grant insert on skw_file to tiptopgp;
grant index on skw_file to public;
grant select on skw_file to ods;
