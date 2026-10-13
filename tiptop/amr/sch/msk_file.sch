/*
================================================================================
檔案代號:msk_file
檔案名稱:MRP 模拟时距日期档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table msk_file
(
msk_v       varchar2(10) NOT NULL,   /*模拟版本                               */
                                     /*模擬版本                               */
msk_d       date NOT NULL            /*时距日期                               */
                                     /*時距日期                               */
);

alter table msk_file add  constraint msk_pk primary key  (msk_d,msk_v) enable validate;
grant select on msk_file to tiptopgp;
grant update on msk_file to tiptopgp;
grant delete on msk_file to tiptopgp;
grant insert on msk_file to tiptopgp;
grant index on msk_file to public;
grant select on msk_file to ods;
