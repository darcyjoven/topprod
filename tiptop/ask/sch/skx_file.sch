/*
================================================================================
檔案代號:skx_file
檔案名稱:改码信息表档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table skx_file
(
skx01       varchar2(20) DEFAULT ' ' NOT NULL, /*制单号*/
skx02       varchar2(20) DEFAULT ' ' NOT NULL, /*款式号*/
skx03       number(5) DEFAULT '0' NOT NULL, /*项次*/
skx04       varchar2(6),
skx05       varchar2(6),
skx06       varchar2(6),
skx07       varchar2(40),
skxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skxlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table skx_file add  constraint skx_pk primary key  (skx01,skx02,skx03) enable validate;
grant select on skx_file to tiptopgp;
grant update on skx_file to tiptopgp;
grant delete on skx_file to tiptopgp;
grant insert on skx_file to tiptopgp;
grant index on skx_file to public;
grant select on skx_file to ods;
