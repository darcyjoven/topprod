/*
================================================================================
檔案代號:mpk_file
檔案名稱:MPS 模拟时距日期档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mpk_file
(
mpk_v       varchar2(10) NOT NULL,   /*模拟版本                               */
                                     /*模擬版本                               */
                                     /*空白表示為release為MPS計劃時的時距     */
mpk_d       date NOT NULL            /*时距日期                               */
                                     /*時距日期                               */
);

alter table mpk_file add  constraint mpk_pk primary key  (mpk_d,mpk_v) enable validate;
grant select on mpk_file to tiptopgp;
grant update on mpk_file to tiptopgp;
grant delete on mpk_file to tiptopgp;
grant insert on mpk_file to tiptopgp;
grant index on mpk_file to public;
grant select on mpk_file to ods;
