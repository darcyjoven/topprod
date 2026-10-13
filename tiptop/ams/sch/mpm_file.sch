/*
================================================================================
檔案代號:mpm_file
檔案名稱:MPS 模拟时距日期/供需日期归属档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mpm_file
(
mpm_v       varchar2(10) NOT NULL,   /*模拟版本                               */
                                     /*模擬版本                               */
                                     /*空白表示為release為MPS計劃時的時距     */
mpm_d       date NOT NULL,           /*时距日期                               */
                                     /*時距日期                               */
mpm_act     date NOT NULL            /*供需日期                               */
);

alter table mpm_file add  constraint mpm_pk primary key  (mpm_d,mpm_v,mpm_act) enable validate;
grant select on mpm_file to tiptopgp;
grant update on mpm_file to tiptopgp;
grant delete on mpm_file to tiptopgp;
grant insert on mpm_file to tiptopgp;
grant index on mpm_file to public;
grant select on mpm_file to ods;
