/*
================================================================================
檔案代號:mse_file
檔案名稱:指定厂牌名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mse_file
(
mse01       varchar2(24) NOT NULL,   /*指定厂牌编号                           */
                                     /*指定廠牌編號                           */
mse02       varchar2(80)             /*厂牌名称                               */
                                     /*廠牌名稱                               */
);

alter table mse_file add  constraint mse_pk primary key  (mse01) enable validate;
grant select on mse_file to tiptopgp;
grant update on mse_file to tiptopgp;
grant delete on mse_file to tiptopgp;
grant insert on mse_file to tiptopgp;
grant index on mse_file to public;
grant select on mse_file to ods;
