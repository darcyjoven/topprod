/*
================================================================================
檔案代號:skc_file
檔案名稱:裁剪拉布登记档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table skc_file
(
skc01       varchar2(20) DEFAULT ' ' NOT NULL, /*制单号*/
skc02       varchar2(20) DEFAULT ' ' NOT NULL, /*款式号*/
skc03       number(5) DEFAULT '0' NOT NULL, /*床号*/
skc04       date,                    /*制定日期                               */
skc05       varchar2(6),             /*no use                                 */
skc06       varchar2(6),             /*颜色编码                               */
skc07       number(15,3),            /*no use                                 */
skc08       varchar2(40),
skc09       number(5),
skcconf     varchar2(1),
skcdate     date,                    /*资料更改日期                           */
skcgrup     varchar2(10),
skcmodu     varchar2(10),            /*资料更改者                             */
skcuser     varchar2(10),            /*资料用户                               */
skcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skclegal    varchar2(10) NOT NULL,   /*所属法人                               */
skcoriu     varchar2(10),            /*资料建立者                             */
skcorig     varchar2(10)             /*资料建立部门                           */
);

alter table skc_file add  constraint skc_pk primary key  (skc01,skc02,skc03) enable validate;
grant select on skc_file to tiptopgp;
grant update on skc_file to tiptopgp;
grant delete on skc_file to tiptopgp;
grant insert on skc_file to tiptopgp;
grant index on skc_file to public;
grant select on skc_file to ods;
