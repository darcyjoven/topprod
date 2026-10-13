/*
================================================================================
檔案代號:oat_file
檔案名稱:客戶交貨運輸天數檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oat_file
(
oat01       varchar2(10) DEFAULT ' ' NOT NULL, /*区域*/
oat02       varchar2(10) DEFAULT ' ' NOT NULL, /*国家*/
oat03       varchar2(10) DEFAULT ' ' NOT NULL, /*地区*/
oat04       varchar2(6) DEFAULT ' ' NOT NULL, /*价格条件*/
oat05       number(5)                /*天数                                   */
);

alter table oat_file add  constraint oat_pk primary key  (oat01,oat02,oat03,oat04) enable validate;
grant select on oat_file to tiptopgp;
grant update on oat_file to tiptopgp;
grant delete on oat_file to tiptopgp;
grant insert on oat_file to tiptopgp;
grant index on oat_file to public;
grant select on oat_file to ods;
