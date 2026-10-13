/*
================================================================================
檔案代號:mpw_file
檔案名稱:销售生产库存计划每日明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mpw_file
(
mpw00       number(10) NOT NULL,     /*资料序号                               */
                                     /*資料序號 (用此欄位和單頭的資料做join)  */
mpw01       date NOT NULL,           /*计划日期                               */
                                     /*計劃日期                               */
mpw10       number(15,3)             /*当日计划数量                           */
                                     /*當日計劃數量                           */
);

alter table mpw_file add  constraint mpw_pk primary key  (mpw00,mpw01) enable validate;
grant select on mpw_file to tiptopgp;
grant update on mpw_file to tiptopgp;
grant delete on mpw_file to tiptopgp;
grant insert on mpw_file to tiptopgp;
grant index on mpw_file to public;
grant select on mpw_file to ods;
