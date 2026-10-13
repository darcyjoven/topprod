/*
================================================================================
檔案代號:rtc_file
檔案名稱:组装商品结构资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rtc_file
(
rtc01       varchar2(40) DEFAULT ' ' NOT NULL, /*组装商品主项商品代码*/
rtc02       varchar2(40) DEFAULT ' ' NOT NULL, /*组装产品子项产品编号*/
rtc03       varchar2(4),             /*子项产品库存单位                       */
rtc04       number(5)                /*子项产品数量                           */
);

alter table rtc_file add  constraint rtc_pk primary key  (rtc01,rtc02) enable validate;
grant select on rtc_file to tiptopgp;
grant update on rtc_file to tiptopgp;
grant delete on rtc_file to tiptopgp;
grant insert on rtc_file to tiptopgp;
grant index on rtc_file to public;
grant select on rtc_file to ods;
